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
      
      define_file_task( File.join(@build_dir, 'packages') )
      define_file_task( File.join(@build_dir, 'debian', 'README.Debian'), :readme )
      define_file_task( File.join(@build_dir, 'debian', 'changelog') )
      define_file_task( File.join(@build_dir, 'debian', 'config') )
      define_file_task( File.join(@build_dir, 'debian', 'control') )
      define_file_task( File.join(@build_dir, 'debian', 'copyright') )
      define_file_task( File.join(@build_dir, 'debian', 'postinst') )
      define_file_task( File.join(@build_dir, 'debian', 'rules') )
      define_file_task( File.join(@build_dir, 'debian', 'templates') )
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
    def define_file_task( fileNameString, attribute=nil )
      file( fileNameString ) do |task|
        if attribute && @spec.send(attribute)
          open( task.name, 'w+' ) do |outfile|
            outfile.print( @spec.send(attribute) )
          end
        elsif @spec.send(File.basename(fileNameString))
          open( task.name, 'w+' ) do |outfile|
            outfile.print( @spec.send(File.basename(fileNameString)) )
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