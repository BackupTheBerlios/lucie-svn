#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'

module LMP
  # LMP �p�b�P�[�W�쐬�ɕK�v�ȃt�@�C���� Rake �^�[�Q�b�g�̓o�^�A
  # ����� LMP �p�b�P�[�W�̃r���h���s��
  class Builder
    # �p�b�P�[�W�쐬�ɕK�v�Ȋe�t�@�C���� Rake �^�[�Q�b�g���`����
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
    
    # Specification ������ LMP ���r���h����B
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