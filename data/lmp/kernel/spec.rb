#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

template( 'kernel/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'kernel �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ��������ɤǤ� kernel �������Ԥ��ޤ���
  �����ǽ�ʹ��ܤϰʲ����̤�Ǥ���

   o ���󥹥ȡ��뤹�륫���ͥ�ΥС������

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  DESCRIPTION_JA
end

question( 'kernel/hello' => 'kernel/kernel-version' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- �����ͥ�С����������
template( 'kernel/kernel-version' ) do |template|
  template.template_type = 'select'
  template.choices = '2.4.22, 2.6.0, 2.2.0'
  template.short_description_ja = '���󥹥ȡ��뤹�륫���ͥ�ΥС������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���󥹥ȡ��뤹�륫���ͥ�ΥС�����������Ǥ���������
  DESCRIPTION_JA
end

question( 'kernel/kernel-version' =>
proc do |user_input|
  subst 'kernel/confirmation', 'kernel-version', user_input
  'kernel/confirmation'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- �������γ�ǧ

template( 'kernel/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '�������γ�ǧ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���������ǧ���ޤ���

   o �����ͥ�С������: ${kernel-version}

  DESCRIPTION_JA
end

question( 'kernel/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP �����.

spec = LMP::Specification.new do |spec|
  spec.name = "kernel"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[�᥿�ѥå�����] kernel'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
  Included packages:

   o FIXME

  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'test/lmp/build'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
