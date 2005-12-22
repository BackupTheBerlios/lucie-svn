#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# ------------------------- 

template( 'lucie-client/xen/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'Xen �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ��������ɤǤ� Xen 3.0.0 �������Ԥ��ޤ���

  ���Υѥå������򥤥󥹥ȡ��뤹�뤿��ˤ� lmp-grub ��ɬ�פǤ���

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-client/xen/hello' => 'lucie-client/xen/memory' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/xen/memory' ) do |template|
  template.template_type = 'string'
  template.default = '131072'
  template.short_description_ja = 'Xen Domain0 �����̤�����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Xen Domain0 �˳�����Ƥ�����̤����Ϥ��Ƥ���������(ñ��: kbytes)
  DESCRIPTION_JA
end

question( 'lucie-client/xen/memory' => 'lucie-client/xen/kernel' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/kernel' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'Kernel ������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ��ư����륫���ͥ�� Xen0 �����ͥ�ˤ��ޤ�����
  DESCRIPTION_JA
end

question( 'lucie-client/xen/kernel' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
