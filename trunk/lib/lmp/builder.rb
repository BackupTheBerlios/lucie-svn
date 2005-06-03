#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'

module LMP
  # LMP �ѥå�����������ɬ�פʥե������ Rake �������åȤ���Ͽ��
  # ����� LMP �ѥå������Υӥ�ɤ�Ԥ�
  class Builder
    # �ѥå�����������ɬ�פʳƥե������ Rake �������åȤ��������
    public
    def initialize( aSpecification, buildDirPathString )
      @spec = aSpecification
      @build_dir = buildDirPathString
      
      define_file_task( File.join(@build_dir, 'package') )
      define_file_task( File.join(@build_dir, 'debian', 'README.Debian'), :readme )
      define_file_task( File.join(@build_dir, 'debian', 'changelog') )
      define_file_task( File.join(@build_dir, 'debian', 'config') )
      define_file_task( File.join(@build_dir, 'debian', 'control') )
      define_file_task( File.join(@build_dir, 'debian', 'copyright') )
      define_file_task( File.join(@build_dir, 'debian', 'postinst') )
      define_file_task( File.join(@build_dir, 'debian', 'rules') )
      define_file_task( File.join(@build_dir, 'debian', 'templates') )
    end
    
    # Specification �򸵤� LMP ��ӥ�ɤ��롣
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
