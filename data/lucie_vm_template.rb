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
  template.short_description_ja = 'Lucie VM �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Υ��������ɤǤϡ�Lucie ���Ѥ��� VM ���åȥ��åפ���������Ϥ��ޤ���
  �����ǽ�ʹ��ܤϡ�
   o ɬ�פ� VM �����
   o �����ͥåȥ���ؤ���³
   o VM �ǻ��Ѥ����������
   o VM �ǻ��Ѥ���ϡ��ɥǥ���������
   o ���Ѥ��� VM �μ���
   o VM �إ��󥹥ȡ��뤹�� Linux �ǥ����ȥ�ӥ塼�����μ���
   o VM �إ��󥹥ȡ��뤹�륽�եȥ������μ���
  �Ǥ�����ʬ�� VM ������餻��������֤������ˤ�ä��������Ƥ���������

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
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
  template.short_description_ja = 'VM �Ρ��ɤ����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ����������򤷤Ƥ���������

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���ΥΡ��ɿ��ϡ�4 ��� 64 ��ȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/use-network'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = 'VM �γ����ͥåȥ���ؤ���³'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ����ּ¹Ի��� VM �ϳ����ͥåȥ������³����ɬ�פ�����ޤ�����
  ���Υ��ץ����򥪥�ˤ���ȡ�GRAM ����ưŪ�˳� VM ��Ϣ³���� IP ���ɥ쥹�� MAC ���ɥ쥹�������ơ�
  Lucie �򤹤٤ƤΥͥåȥ���ط��������Ԥ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'VM �� IP ���ɥ쥹'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �ʲ��Τ褦�˥ۥ���̾��IP ���ɥ쥹��MAC ���ɥ쥹���꿶��ޤ�����
  ���Ѳ�ǽ�� VM �� pad000 - pad003 �� 4 �Ρ��ɤǤ���
  
   �ۥ���̾: pad000
   IP ���ɥ쥹: 168.220.98.30
   MAC ���ɥ쥹: 00:50:56:01:02:02

   �ۥ���̾: pad001
   IP ���ɥ쥹: 163.220.98.31
   MAC ���ɥ쥹: 00:50:56:01:02:03

   �ۥ���̾: pad002
   IP ���ɥ쥹: 163.220.98.32
   MAC ���ɥ쥹: 00:50:56:01:02:04

   �ۥ���̾: pad003
   IP ���ɥ쥹: 163.220.98.33
   MAC ���ɥ쥹: 00:50:56:01:02:05
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
  template.short_description_ja = 'VM �Ρ��ɤΥ�������'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ���椢����Υ������̤����򤷤Ƥ���������ñ�̤� MB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υ������̤� 640 MB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥ������̤����򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['1', '2', '3', '4']
  template.short_description_ja = 'VM �Ρ��ɤΥϡ��ɥǥ���������'  
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ���椢����Υϡ��ɥǥ��������̤����򤷤Ƥ���������ñ�̤� GB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υϡ��ɥǥ��������̤� 4GB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥϡ��ɥǥ��������̤����򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'colinux', 'vmware']
  template.short_description_ja = '���Ѥ��� VM �μ���'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ����ּ¹Ԥ˻��Ѥ��� VM �����μ�������򤷤Ƥ�������
  .
  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ������ 
  'Xen (����֥�å���)', 'colinux (www.colinux.org)', 'vmware (VMware, Inc.)' �� 3 ����Ǥ���
  ���줾�����ħ�ϰʲ����̤�Ǥ���
   o Xen: Disk I/O �����Ū��®�Ǥ���
   o coLinux: Network I/O �����Ū��®�Ǥ���
   o vmware: CPU �����Ū��®�Ǥ���
  ����֤η׻����Ƥ˹�ä� VM ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '���Ѥ���ǥ����ȥ�ӥ塼�����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��� Linux �ǥ����ȥ�ӥ塼���������򤷤Ƥ�������
  .
  ������ PrestoIII ���饹�����󶡤Ǥ��� Linux �ǥ����ȥ�ӥ塼������ 
  'Debian (woody)', 'Debian (sarge)', 'Redhat 7.3' �� 3 ����Ǥ���
  ���줾�����ħ�ϰʲ����̤�Ǥ���
   o Debian GNU/Linux (woody): Debian �ΰ����ǤǤ���
   o Debian GNU/Linux (sarge): Debian �γ�ȯ�ǤǤ������Ū�������ѥå�������ޤޤ�ޤ���
   o RedHat 7.3: RedHat �ΰ����ǤǤ���
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
  template.short_description_ja = '���Ѥ��륢�ץꥱ�������'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��륽�եȥ������ѥå����������Ϥ��Ƥ�������

  ������ PrestoIII ���饹���ǥǥե���Ȥǥ��󥹥ȡ��뤵��륽�եȥ������ѥå������ϰʲ����̤�Ǥ���
   o ���ܥѥå�����: fileutils, findutils �ʤɤδ���Ū�ʥ桼�ƥ���ƥ�
   o ������: tcsh, bash, zsh �ʤɤΥ�����
   o �ͥåȥ���ǡ����: ssh �� rsh, ftp �ʤɤΥǡ����
  �嵭���ɲä��ƥ��󥹥ȡ��뤷�����ѥå������򥳥�޶��ڤ�����Ϥ��Ƥ���������
  
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
