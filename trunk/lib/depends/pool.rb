# = pool.rb - Pools all of package dependency information.
# 
# $Id: pool.rb,v 1.9 2004/06/30 06:54:06 takamiya Exp $
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision: 1.9 $
# License::  GPL2

require 'English'


module Depends
  class Pool


    ##
    # Returns a new Pool object.
    #
    # _Example_:
    #  Pool.new -> aNewPool
    #
    def initialize( statusString = nil )
      @pool = {}
      @packages_depends_to = Hash.new([])
      @npackage = 0

      packages( statusString ).each { |each|
        register_package each
        STDERR.print @npackage, "\r" 
      }
      cache_dependency
      
      STDERR.printf("%d packages and %d virtual packages available, %d installed\n",
                    @npackage, n_virtual_packages, n_installed_packages)
    end


    public
    def package( packageNameString )
      name2package packageNameString
    end

    
    private
    def packages( statusString )
      if statusString
        statusString.split "\n\n"
      else
        IO.readlines STATUS, "\n\n"
      end
    end


    private
    def n_virtual_packages
      @pool.values.select { |each| each.status[0] == 'virtual' }.size
    end


    private
    def n_installed_packages
      @pool.size - n_virtual_packages
    end


    private
    def cache_dependency
      @pool.values.each { |package|
        package.depends.each { |dependency|
          next if @pool[dependency.name].nil?
          @packages_depends_to[dependency.name] |= [package]
        }}
    end


    private
    def register_package( controlString )
      package = Package.new( controlString )
      @npackage += 1
      @pool[package.name] = package if (package.status and ( package.status[2] == "installed" ))
      package.provides.each { |each| 
        @pool[each] = Package.new( "Package: #{each}\nStatus: virtual" )
      }
    end


    # Check if +packageNameString+ conflicts with +otherPackageNameString+?
    # This method returns boolean value.
    #
    # _Example_:
    #  aPool.conflict?('gcc', 'lv')    #=> false
    #  aPool.conflict?('lam', 'mpich') #=> true
    #
    # a RuntimeError will be thrown when +packageNameString+ or
    # +otherPackageNameString+ package not found.
    #
    public
    def conflict?( packageNameString, otherPackageNameString )
      other_package = name2package( otherPackageNameString )
      conflict_dependency = conflict_dependency( packageNameString, otherPackageNameString )
      return false unless conflict_dependency
      conflict_dependency.relation.call other_package 
    end


    ##
    # Returns an Array of Dependency object containing conflicting
    # packages' dependency information.
    #
    # _Example_:
    #  aPool.conflicts('gcc') #=>
    #   [#<Dependency:0x40762424 @version="1:2.95.3", @name="gcc-doc", @relation="<<">]
    # 
    public
    def conflicts( packageNameString )
      package = name2package( packageNameString )
      if package.conflicts
        return package.conflicts.split(/,\s*/).collect { |each| Dependency.new each }
      else
        []
      end
    end


    ##
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
    #
    public
    def deps( packageNameString, level=1 )
      dependencies = Hash.new([])
      @pool.each { |name, package|
	if name == packageNameString
	  dependencies[:forward] += forward_dependency( packageNameString, level )
	  dependencies[:reverse] += reverse_dependency( packageNameString, level )
	  dependencies[:provided] += provided_dependency( package, level )
	else
	  package.provides.each { |each|
            dependencies[:reverse] += reverse_dependency( name, level ) if each == packageNameString
	  }
	end
      }
      dependencies
    end


    private
    def conflict_dependency( packageNameString, otherPackageNameString )
      conflicts( packageNameString ).select { |c|
	otherPackageNameString == c.name
      }[0]
    end
    

    private
    def name2package( packageNameString )
      if @pool[packageNameString]
        return @pool[packageNameString]
      else
	rec = `apt-cache show #{packageNameString}`.split('\n\n')[0]
        raise "Package '#{packageNameString}' not found." unless rec
	@pool[packageNameString] = Package.new(rec)
      end
    end


    private
    def forward_dependency( packageNameString, level )
      return if level == 0
      if level == 1
        @pool[packageNameString].depends.collect { |each| @pool[each.name] }
      elsif level >=2
        (@pool[packageNameString].depends + 
         @pool[packageNameString].depends.collect { |each| each.name }.collect { |each|
           forward_dependency each, level-1
         }).flatten
      else
        raise 'this shouldn\'t happen'
      end
    end


    private
    def reverse_dependency( packageNameString, level )
      return if level == 0
      result = []
      @packages_depends_to[packageNameString].each { |each|
	result << each
        result += reverse_dependency(each.name, level-1) if level >= 2
      }
      result.uniq
    end


    private
    def provided_dependency( aPackage, level )
      aPackage.provides.collect { |each| 
	reverse_dependency each, level
      }.flatten
    end


  end
end 


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
