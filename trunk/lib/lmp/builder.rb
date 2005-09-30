#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'

module LMP
  # LMP パッケージ作成に必要なファイルの Rake ターゲットの登録、
  # および LMP パッケージのビルドを行う
  class Builder
    # パッケージ作成に必要な各ファイルの Rake ターゲットを定義する
    public
    def initialize( aSpecification, buildDirPathString )
      @spec = aSpecification
      @build_dir = buildDirPathString

      task :clean do 
        debian_files.each do |each|
          rm each[:path] rescue nil
        end
      end
      debian_files.each do |each|
        define_file_task( each[:path], each[:template_name] )
      end
    end
    
    # Specification を元に LMP をビルドする。
    public
    def build
      sh "cd #{@build_dir} && debuild" do |ok, res|
        if ! ok
          puts "debuild failed (status = #{res.exitstatus})"
        end
      end
    end
       
    private
    def debian_files
      [ { :path => File.join(@build_dir, 'debian', 'README.Debian'), :template_name => :readme }, 
        { :path => File.join(@build_dir, 'debian', 'changelog') },
        { :path => File.join(@build_dir, 'debian', 'config') },
        { :path => File.join(@build_dir, 'debian', 'control') },
        { :path => File.join(@build_dir, 'debian', 'copyright') },
        { :path => File.join(@build_dir, 'debian', 'postinst') },
        { :path => File.join(@build_dir, 'debian', 'rules') },
        { :path => File.join(@build_dir, 'debian', 'templates') } ]
    end

    private
    def define_file_task( filePathString, templateNameString=nil )
      file( filePathString ) do |task|
        if templateNameString && @spec.send(templateNameString)
          open( task.name, 'w+' ) do |outfile|
            outfile.print( @spec.send(templateNameString) )
          end
        elsif @spec.send(File.basename(filePathString))
          open( task.name, 'w+' ) do |outfile|
            outfile.print( @spec.send(File.basename(filePathString)) )
          end
        end
      end     
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
