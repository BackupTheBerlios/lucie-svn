#
# $Id: lucie_vm_template.rb 106 2005-02-11 14:03:23Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 106 $
# License::  GPL2

$KCODE = 'EUCJP'
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

question( 'lucie-vmsetup/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/num-nodes'
  question.first_question = true
end

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['4', '8', '12', '16', '20', '24', '28', '32', '36', '40', '44', '48', '52', '56', '60', '64']
  template.short_description_ja = 'VM �m�[�h�̑䐔'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM �̑䐔��I�����Ă��������B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̃m�[�h���́A4 ��` 64 ��ƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȑ䐔��I�����Ă��������B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/use-network'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = '�m�[�h�̃l�b�g���[�N'
  template.extended_description_ja = '�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H'
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�� ip �A�h���X'
  template.extended_description_ja = '�m�[�h�� IP �A�h���X�́H'
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�̃������e��'
  template.extended_description_ja = '�g�p�������������e�ʂ���͂��Ă������� (�P��: MB)'
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�m�[�h�̃n�[�h�f�B�X�N�e��'
  template.extended_description_ja = '�g�p�������n�[�h�f�B�X�N�e�ʂ����Ă������� (�P��: MB)'
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'umlinux', 'colinux', 'vmware']
  template.short_description_ja = '�g�p���� VM �̎��'
  template.extended_description_ja = '�g�p���� VM ��I�����Ă�������'
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '�g�p����f�B�X�g���r���[�V�����̑I��'
  template.extended_description_ja = '�g�p����f�B�X�g���r���[�V������I�����Ă�������'
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/application'
end

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = MultiselectTemplate
  template.choices = ['ruby', 'perl', 'java']
  template.short_description_ja = '�g�p����A�v���P�[�V�����̑I��'
  template.extended_description_ja = '�g�p����A�v���P�[�V������I�����Ă�������'
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
