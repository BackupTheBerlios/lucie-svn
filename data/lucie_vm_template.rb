#
# $Id: lucie_vm_template.rb 106 2005-02-11 14:03:23Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 106 $
# License::  GPL2

require 'lucie'

include Lucie

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���̃E�B�U�[�h�ł́ALucie ��p���� VM �Z�b�g�A�b�v�̐ݒ����͂��܂��B
  �ݒ�\�ȍ��ڂ́A
   o �K�v�� VM �̑䐔
   o �O���l�b�g���[�N�ւ̐ڑ�
   o VM �Ŏg�p���郁�����e��
   o VM �Ŏg�p����n�[�h�f�B�X�N�e��
   o �g�p���� VM �̎��
   o VM �փC���X�g�[������ Linux �f�B�X�g���r���[�V�����̎��
   o VM �փC���X�g�[������\�t�g�E�F�A�̎��
  �ł��B������ VM ��ő��点�����W���u�̓����ɂ���Đݒ�����߂Ă��������B

  �u���ցv���N���b�N����ƃE�B�U�[�h���J�n���܂��B
  DESCRIPTION_JA
end

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = 'VM �m�[�h�䐔�̑I���ł�'
  template.extended_description_ja = '�g�p������ VM �̑䐔�����Ă�������'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = '�m�[�h�̃l�b�g���[�N'
  template.extended_description_ja = '�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H'
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�� ip �A�h���X'
  template.extended_description_ja = '�m�[�h�� IP �A�h���X�́H'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�̃������e��'
  template.extended_description_ja = '�g�p�������������e�ʂ���͂��Ă������� (�P��: MB)'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�̃n�[�h�f�B�X�N�e��'
  template.extended_description_ja = '�g�p�������n�[�h�f�B�X�N�e�ʂ����Ă������� (�P��: MB)'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'umlinux', 'colinux', 'vmware']
  template.short_description_ja = '�g�p���� VM �̎��'
  template.extended_description_ja = '�g�p���� VM ��I�����Ă�������'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '�g�p����f�B�X�g���r���[�V�����̑I��'
  template.extended_description_ja = '�g�p����f�B�X�g���r���[�V������I�����Ă�������'
end

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = MultiselectTemplate
  template.choices = ['ruby', 'perl', 'java']
  template.short_description_ja = '�g�p����A�v���P�[�V�����̑I��'
  template.extended_description_ja = '�g�p����A�v���P�[�V������I�����Ă�������'
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
