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

      task :clean do 
        debian_files.each do |each|
          rm each[:path] rescue nil
        end
      end
      debian_files.each do |each|
        define_file_task( each[:path], each[:template_name] )
      end
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
