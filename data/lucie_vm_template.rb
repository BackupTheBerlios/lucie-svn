#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'

include Deft

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
  template.short_description_ja = 'VM �̊O���l�b�g���[�N�ւ̐ڑ�'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �W���u���s���� VM �͊O���l�b�g���[�N�֐ڑ�����K�v������܂����H
  ���̃I�v�V�������I���ɂ���ƁAGRAM �������I�Ɋe VM �ɘA������ IP �A�h���X�� MAC �A�h���X�����蓖�āA
  Lucie �����ׂẴl�b�g���[�N�֌W�̐ݒ���s���܂��B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'VM �� IP �A�h���X'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �ȉ��̂悤�Ƀz�X�g���AIP �A�h���X�AMAC �A�h���X������U��܂����B
  �g�p�\�� VM �� pad000 - pad003 �� 4 �m�[�h�ł��B
  
   �z�X�g��: pad000
   IP �A�h���X: 168.220.98.30
   MAC �A�h���X: 00:50:56:01:02:02

   �z�X�g��: pad001
   IP �A�h���X: 163.220.98.31
   MAC �A�h���X: 00:50:56:01:02:03

   �z�X�g��: pad002
   IP �A�h���X: 163.220.98.32
   MAC �A�h���X: 00:50:56:01:02:04

   �z�X�g��: pad003
   IP �A�h���X: 163.220.98.33
   MAC �A�h���X: 00:50:56:01:02:05
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
  template.short_description_ja = 'VM �m�[�h�̃������e��'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM ��䂠����̃������e�ʂ�I�����Ă��������B�P�ʂ� MB �ł��B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̂P�m�[�h������̃������e�ʂ� 640 MB �܂łƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȃ������e�ʂ�I�����Ă��������B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['1', '2', '3', '4']
  template.short_description_ja = 'VM �m�[�h�̃n�[�h�f�B�X�N�e��'  
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM ��䂠����̃n�[�h�f�B�X�N�e�ʂ�I�����Ă��������B�P�ʂ� GB �ł��B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̂P�m�[�h������̃n�[�h�f�B�X�N�e�ʂ� 4GB �܂łƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȃn�[�h�f�B�X�N�e�ʂ�I�����Ă��������B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'colinux', 'vmware']
  template.short_description_ja = '�g�p���� VM �̎��'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �W���u���s�Ɏg�p���� VM �����̎�ނ�I�����Ă�������
  .
  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM ������ 
  'Xen (�P���u���b�W��)', 'colinux (www.colinux.org)', 'vmware (VMware, Inc.)' �� 3 ��ނł��B
  ���ꂼ��̓����͈ȉ��̒ʂ�ł��B
   o Xen: Disk I/O ����r�I�����ł��B
   o coLinux: Network I/O ����r�I�����ł��B
   o vmware: CPU ����r�I�����ł��B
  �W���u�̌v�Z���e�ɍ����� VM ������I�����Ă��������B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '�g�p����f�B�X�g���r���[�V����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �ɃC���X�g�[�����Ďg�p���� Linux �f�B�X�g���r���[�V������I�����Ă�������
  .
  ������ PrestoIII �N���X�^�Œ񋟂ł��� Linux �f�B�X�g���r���[�V������ 
  'Debian (woody)', 'Debian (sarge)', 'Redhat 7.3' �� 3 ��ނł��B
  ���ꂼ��̓����͈ȉ��̒ʂ�ł��B
   o Debian GNU/Linux (woody): Debian �̈���łł��B
   o Debian GNU/Linux (sarge): Debian �̊J���łł��B��r�I�V�����p�b�P�[�W���܂܂�܂��B
   o RedHat 7.3: RedHat �̈���łł��B
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = Proc.new do |input|
    case input
    when 'debian (woody)', 'debian (sarge)'
      'lucie-vmsetup/application'
    when 'redhat7.3'
      nil
    end
  end
end

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = '�g�p����A�v���P�[�V����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �ɃC���X�g�[�����Ďg�p����\�t�g�E�F�A�p�b�P�[�W����͂��Ă�������

  ������ PrestoIII �N���X�^�Ńf�t�H���g�ŃC���X�g�[�������\�t�g�E�F�A�p�b�P�[�W�͈ȉ��̒ʂ�ł��B
   o ��{�p�b�P�[�W: fileutils, findutils �Ȃǂ̊�{�I�ȃ��[�e�B���e�B
   o �V�F��: tcsh, bash, zsh �Ȃǂ̃V�F��
   o �l�b�g���[�N�f�[����: ssh �� rsh, ftp �Ȃǂ̃f�[����
  ��L�ɒǉ����ăC���X�g�[���������p�b�P�[�W���R���}��؂�œ��͂��Ă��������B
  
  ��: ruby, python, blast2
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
