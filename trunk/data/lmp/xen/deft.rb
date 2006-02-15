#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
require 'lucie/installer'
include Deft
include Lucie::Installer

# ------------------------- 

template( 'lucie-client/xen/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-xen setup wizard'
  template.short_description_ja = 'Xen �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup Xen VMM.

  This package require lmp-grub metapackage.

  DESCRIPTION

  template.extended_description_ja = <<-DESCRIPTION_JA
  ���̃E�B�U�[�h�ł� Xen �̐ݒ���s���܂��B

  ���̃p�b�P�[�W���C���X�g�[�����邽�߂ɂ� lmp-grub ���K�v�ł��B

  DESCRIPTION_JA
end

question( 'lucie-client/xen/hello' =>
proc do
  subst 'lucie-client/xen/guest', 'installer_name', "#{installer_resource.name}"
  subst 'lucie-client/xen/bye', 'installer_name', "#{installer_resource.name}"
  'lucie-client/xen/memory' 
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/xen/memory' ) do |template|
  template.template_type = 'string'
  template.default = '131072'
  template.short_description = 'Configure memory amount'
  template.short_description_ja = '�������ʂ̐ݒ�'
  template.extended_description = <<-DESCRIPTION
  Please enter an amount of memory size used by Xen Domain0. (kbytes)
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  Xen Domain0 �Ɋ��蓖�Ă郁�����ʂ���͂��Ă��������B(�P��: kbytes)
  DESCRIPTION_JA
end

question( 'lucie-client/xen/memory' => 'lucie-client/xen/kernel' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/kernel' ) do |template|
  template.template_type = 'boolean'
  template.short_description = 'Select Kernel'
  template.short_description_ja = 'Kernel �̑I��'
  template.extended_description = <<-DESCRIPTION
  Make Xen0 first boot kernel ?
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �N�������J�[�l���� Xen0 �J�[�l���ɂ��܂����H
  DESCRIPTION_JA
end

question( 'lucie-client/xen/kernel' => 'lucie-client/xen/guest' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/guest' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Configurate guest image'
  template.short_description_ja = '�Q�X�g�̐ݒ�'
  template.extended_description = <<-DESCRIPTION
  If you want to deploy your Xen guest image file and config file, put these in directories shown below.

  These files will be copied into /var/xen/ .

   o Image : /etc/lucie/${installer_name}/xen/disk/
   o Config : /etc/lucie/${installer_name}/xen/config/

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �Q�X�g�h���C���ŗp����C���[�W�t�@�C���Ɛݒ�t�@�C����p�������ꍇ�A�ȉ��̃f�B���N�g����
  �����̃t�@�C����u���Ă��������B

  �����̃t�@�C���� /var/xen/ �ȉ��ɃR�s�[����܂��B

   o �C���[�W : /etc/lucie/${installer_name}/xen/disk/
   o �ݒ�t�@�C�� : /etc/lucie/${installer_name}/xen/config/
  
  DESCRIPTION_JA
end

question( 'lucie-client/xen/guest' => 'lucie-client/xen/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/bye' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Important!'
  template.short_description_ja = '�d�v�I'
  template.extended_description = <<-DESCRIPTION
  Put xen binary installer directory as shown below and then, click OK.

  /etc/lucie/${installer_name}/xen/installer/
   (Ex: /etc/lucie/${installer_name}/xen/installer/xen-3.0.0-install/)

  Note: This binary installer directory must include Xen intaller (install.sh).
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  Xen �o�C�i���C���X�g�[���f�B���N�g�����ȉ��ɂ��邱�Ƃ��m�F���A�n�j���N���b�N���Ă��������B

  /etc/lucie/${installer_name}/xen/installer/
   (��: /etc/lucie/${installer_name}/xen/installer/xen-3.0.0-install/)

  ��: ���̃o�C�i���C���X�g�[���f�B���N�g���ɂ́AXen �C���X�g�[�� (install.sh) ���u����Ă���K�v������܂��B
  DESCRIPTION_JA
end

question( 'lucie-client/xen/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: