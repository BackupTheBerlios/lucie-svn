#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Rake
  # �C���X�g�[���̃x�[�X�V�X�e�����r���h����^�X�N���쐬����B
  #
  # InstallerBaseTask �͎��̃^�[�Q�b�g���쐬����:
  #
  # [<b><em>installer_base</em></b>]
  #   InstallerBase �^�X�N�̃��C���^�X�N
  # [<b><em>:clobber_installer_base</em></b>]
  #   ���ׂẴC���X�g�[���x�[�X�֘A�t�@�C������������B
  #   ���̃^�[�Q�b�g�͎����I�Ƀ��C���� clobber �^�[�Q�b�g�ɒǉ������
  # [<b><em>:reinstaller_base</em></b>]
  #   �^�C���X�^���v�Ɋւ�炸�C���X�g�[���x�[�X���܂����炩�烊�r���h����
  #
  # ��:
  #
  #   InstallerBaseTask.new do |installer_base|
  #     installer_base.directory = "tmp"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "sarge"
  #   end
  #
  # �쐬���� InstallerBaseTask �ɂ̓f�t�H���g�̖��O�ȊO�Ɏ����̍D���Ȗ��O��
  # ���邱�Ƃ��ł���B
  #
  #   InstallerBaseTask.new(:installer_base_woody) do |installer_base|
  #     installer_base.directory = "tmp"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "woody"
  #   end
  # 
  # ���̏ꍇ�A<em>:installer_base_woody</em>, :clobber_<em>installer_base_woody</em>, 
  # :re<em>installer_base_woody</em> �Ƃ������O�̃^�X�N�����������B
  #
  class InstallerBaseTask
    # �C���X�g�[���x�[�X�쐬�^�X�N�̖��O (�f�t�H���g: :installer_base )
    attr_accessor :name
    # �C���X�g�[���x�[�X���쐬����f�B���N�g���ւ̃p�X 
    # (�f�t�H���g: '/var/lib/lucie/installer-base/' )
    attr_accessor :directory
    # �C���X�g�[���x�[�X�̃f�B�X�g���r���[�V���� (�f�t�H���g: nil)
    attr_accessor :distribution
    # �C���X�g�[���x�[�X�̃f�B�X�g���r���[�V�����̃o�[�W���� (�f�t�H���g: nil)
    attr_accessor :distribution_version
    
    # InstallerBase �^�X�N���쐬����B�f�t�H���g�̖��O�� +installer_base+
    public
    def initialize( name=:installer_base ) # :yield: self
      @name = name
      @directory = '/var/lib/lucie/installer-base/'
      yield self if block_given?
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: