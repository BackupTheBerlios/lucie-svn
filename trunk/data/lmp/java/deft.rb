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

template( 'lucie-client/java/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-java setup wizard'
  template.short_description_ja = 'Java �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup Java runtime environment.

  DESCRIPTION

  template.extended_description_ja = <<-DESCRIPTION_JA
  ���̃E�B�U�[�h�ł� Java ���s���̐ݒ���s���܂��B

  DESCRIPTION_JA
end

question( 'lucie-client/java/hello' =>
proc do
  subst 'lucie-client/java/note', 'installer_name', "#{installer_resource.name}"
  'lucie-client/java/note'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/java/note' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Important !'
  template.short_description_ja = '�d�v !'
  template.extended_description = <<-DESCRIPTION
  This megapackage require JRE binary directory in path shown below. 
   (If there not, installe not completed.)

   1. Donwload binary installer (jre-*.bin) at Sun web site ( http://java.sun.com/ ). 
    (Ex: jre-1_5_0_06-linux-i586.bin )
   2. Unpack it with licence agreement.
   3. Move unpacked binary directory to /etc/lucie/${installer_name}/java/ as shown below.
    (Ex: /etc/lucie/${installer_name}/java/jre1.5.0_06/ )
  DESCRIPTION

  template.extended_description_ja = <<-DESCRIPTION_JA
  ���̃��^�p�b�P�[�W���C���X�g�[������ɂ́A ���Ɏ����p�X�� JRE �̃o�C�i���f�B���N�g����u���K�v������܂��B
   (�o�C�i�����Ȃ��ꍇ�A�C���X�g�[���͍s���܂���B)

   1. �o�C�i���C���X�g�[�� (jre-*.bin) �� Sun �̃T�C�g ( http://java.sun.com/ ) ����_�E�����[�h����B
    (��: jre-1_5_0_06-linux-i586.bin )
   2. ���C�Z���X���������ĉ𓀂���B
   3. �𓀂��ꂽ�o�C�i���f�B���N�g���� /etc/lucie/${installer_name}/java/ �ȉ��Ɉړ�����B
    (��: /etc/lucie/${installer_name}/java/jre1.5.0_06/ )

  DESCRIPTION_JA
end

question( 'lucie-client/java/note' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: