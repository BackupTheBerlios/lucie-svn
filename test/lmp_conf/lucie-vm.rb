#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie'

include Lucie

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = Template::NOTE
  template.description = (<<-DESCRIPTION)
Hello!
Welcome to Lucie VM setup wizard.
  DESCRIPTION
  template.description_ja = (<<-DESCRIPTION_JA)
����ɂ���
Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
VM �m�[�h�䐔�̑I���ł�
�g�p������ VM �̑䐔�����Ă�������
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = Template::BOOLEAN
  template.default = 'no'
  template.description_ja = (<<-DESCRIPTION_JA)
�m�[�h�̃l�b�g���[�N
�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
�m�[�h�� ip �A�h���X
�m�[�h�� IP �A�h���X�́H
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
�m�[�h�̃������e��
�g�p�������������e�ʂ���͂��Ă������� (�P��: MB)
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
�m�[�h�̃n�[�h�f�B�X�N�e��
�g�p�������n�[�h�f�B�X�N�e�ʂ����Ă������� (�P��: MB)
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = Template::SELECT
  template.choices = ['xen', 'umlinux', 'colinux', 'vmware']
  template.description_ja = (<<-DESCRIPTION_JA)
�g�p���� VM �̎��
�g�p���� VM ��I�����Ă�������
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = Template::SELECT
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.description_ja = (<<-DESCRIPTION_JA)
�g�p����f�B�X�g���r���[�V�����̑I��
�g�p����f�B�X�g���r���[�V������I�����Ă�������
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = Template::MULTISELECT
  template.choices = ['ruby', 'perl', 'java']
  template.description_ja = (<<-DESCRIPTION_JA)
�g�p����A�v���P�[�V�����̑I��
�g�p����A�v���P�[�V������I�����Ă�������
  DESCRIPTION_JA
end.register

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: