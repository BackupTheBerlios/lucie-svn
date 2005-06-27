# 
# $Id$
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'

module Depends
  module Exception
    class UnknownPackageException < ::Exception; end
  end

  # パッケージ間依存情報をプールするためのクラス
  class Pool
    def initialize( statusString = nil )
      @pool = {}
      @packages_depends_to = Hash.new([])
      packages( statusString ).each do |each|
        register_package each
      end
      cache_dependency
    end

    public
    def package( packageNameString )
      string2package packageNameString
    end
    
    private
    def packages( statusString )
      if statusString
        return statusString.split( "\n\n" )
      else
        return IO.readlines( STATUS, "\n\n" )
      end
    end

    private
    def cache_dependency
      @pool.values.each do |package|
        package.depends.each do |dependency|
          next if @pool[dependency.name].nil?
          @packages_depends_to[dependency.name] |= [package]
        end
      end
    end

    private
    def register_package( controlString )
      package = Package.new( controlString )
      @pool[package.name] = package if package.installed?
      package.provides.each do |each| 
        @pool[each] = Package.new( "Package: #{each}\nStatus: virtual" )
      end
    end

    # +packageNameString+ が +otherPackageNameString+ と衝突するかどう
    # かを boolean で返す。
    #
    # _Example_:
    #  aPool.conflict?('gcc', 'lv')    #=> false
    #  aPool.conflict?('lam', 'mpich') #=> true
    #
    # +packageNameString+ や +otherPackageNameString+ パッケージが見つ
    # からない場合には Exception::UnknownPackageException を raise する。
    public
    def conflict?( packageNameString, otherPackageNameString )
      other_package = string2package( otherPackageNameString )
      dependency = conflict_dependency( packageNameString, otherPackageNameString )
      return false unless dependency
      return dependency.relation.call( other_package )
    end

    # +packageNameString+ パッケージに衝突するパッケージの依存関係を表
    # す Dependency オブジェクトからなる Array を返す
    #
    # _Example_:
    #  aPool.conflicts('gcc') #=>
    #   [#<Dependency:0x40762424 @version="1:2.95.3", @name="gcc-doc", @relation="<<">]
    # 
    public
    def conflicts( packageNameString )
      package = string2package( packageNameString )
      if package.conflicts
        return package.conflicts.split(/,\s*/).collect do |each| Dependency.new( each ) end
      else
        return []
      end
    end

    # Returns all of the package dependency information in a Hash
    # object. Each value of Hash is an Array of Package object.
    # Argument +packageNameString+ is a name of package to track
    # dependency, and +level+ is a level of dependency tracking.
    #
    # Package dependency information contains forward, reverse, and
    # provided dependency.
    #
    # _Example_:
    #
    # First of all, new a Dependency object.
    #  deps = aPool.deps('gcc', 3)
    #
    # Now examine all the dependency information of gcc. The first case
    # is forward dependency.
    #  fd   = deps[:forward]
    #  fd.size    #=> 3
    #  fd[0].name #=> 'cpp'
    #  fd[1].name #=> 'gcc-3.3'
    #  fd[2].name #=> 'cpp-3.3'
    # We can see that package `gcc' depends on `cpp', `gcc-3.3' and `cpp-3.3'
    #
    # Reverse dependency:
    #  rd = deps[:reverse]
    #  rd.size    #=> 6
    #  rd[0].name #=> 'gcc-2.95'
    #  rd[1].name #=> 'g++'
    #  rd[2].name #=> 'g++-2.95'
    #  rd[3].name #=> 'libstdc++2.10-dev'
    #  rd[4].name #=> 'kernel-package'
    #  rd[5].name #=> 'libtool'
    # We can see that package 'gcc-2.95', 'g++', 'g++-2.95',
    # 'libstdc++2.10-dev', 'kernel-package' and 'libtool' depend on
    # `gcc'
    #
    # Provided dependency:
    #  pd = deps[:provided]
    #  pd.size    #=> 2
    #  pd[0].name #=> 'kernel-package'
    #  pd[1].name #=> 'libtool'
    # We can see that `gcc' provides c-compiler, and package
    # 'kernel-package' and 'libtool' depend on it.
    public
    def deps( packageNameString, level=1 )
      dependencies = Hash.new([])
      dependencies[:forward]  = forward_dependency(  packageNameString, level )
      dependencies[:reverse]  = reverse_dependency(  packageNameString, level )
      dependencies[:provided] = provided_dependency( packageNameString, level )
      @pool.each_pair do |name, package|
        package.provides.each do |each|
          if each == packageNameString
            dependencies[:reverse] += reverse_dependency( name, level ) 
          end
        end
      end
      return dependencies
    end

    private
    def conflict_dependency( packageNameString, otherPackageNameString )
      target = conflicts( packageNameString ).select do |each|
	otherPackageNameString == each.name
      end
      return target.first
    end

    # パッケージ名から Package オブジェクトを返す。
    # +@pool+ に入っているのは現在システムにインストールされているパッケー
    # ジ情報のみなので、もし知らないパッケージがあった場合には 
    # +apt-cache+ コマンドで調べて返す。
    private
    def string2package( packageNameString )
      return @pool[packageNameString] if @pool[packageNameString]
      rec = `apt-cache show #{packageNameString}`.split('\n\n')[0]
      raise( Exception::UnknownPackageException,
             "Package '#{packageNameString}' not found." ) unless rec
      @pool[packageNameString] = Package.new(rec)
      return @pool[packageNameString]
    end

    private
    def forward_dependency( packageNameString, level )
      return if level == 0
      if level >=2
        depend_packages = string2package(packageNameString).depends.collect do |each|
          each.name 
        end
        forward_forward_dependency = depend_packages.collect do |each| 
          forward_dependency( each, level-1 ) 
        end
        return (string2package(packageNameString).depends + forward_forward_dependency).flatten.compact
      elsif level == 1
        return string2package(packageNameString).depends.collect do |each| @pool[each.name] end
      else
        raise 'this shouldn\'t happen'
      end
    end
    
    private
    def reverse_dependency( packageNameString, level )
      return if level == 0
      result = []
      @packages_depends_to[packageNameString].each do |each|
	result << each
        result += reverse_dependency(each.name, level-1) if level >= 2
      end
      return result.uniq
    end

    private
    def provided_dependency( packageNameString, level )
      @pool[packageNameString].provides.collect do |each| 
	reverse_dependency each, level
      end.flatten
    end
  end
end 

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
