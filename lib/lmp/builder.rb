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
    def initialize( aSpecification )
      @spec = aSpecification
      define_file_task( File.join(@spec.builddir, 'packages') )
      define_file_task( File.join(@spec.builddir, 'debian', 'README.Debian'), :readme )
      define_file_task( File.join(@spec.builddir, 'debian', 'changelog') )
      define_file_task( File.join(@spec.builddir, 'debian', 'config') )
      define_file_task( File.join(@spec.builddir, 'debian', 'control') )
      define_file_task( File.join(@spec.builddir, 'debian', 'copyright') )
      define_file_task( File.join(@spec.builddir, 'debian', 'postinst') )
      define_file_task( File.join(@spec.builddir, 'debian', 'rules') )
      define_file_task( File.join(@spec.builddir, 'debian', 'templates') )
    end
    
    # Specification ������ LMP ���r���h����B
    public
    def build
      sh "(cd #{@spec.builddir}; debuild)" do |ok, res|
        if ! ok
          puts "debuild failed (status = #{res.exitstatus})"
        end
      end
    end
       
    private
    def define_file_task( fileNameString, attribute=nil )
      file( fileNameString ) do |task|
        open( task.name, 'w+' ) do |outfile|
          if attribute
            outfile.print( @spec.send(attribute) )
          else
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