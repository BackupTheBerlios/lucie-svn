#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# ------------------------- ���顼ɽ���ѥƥ�ץ졼��/���� 

def error_backup( shortMessageString, longMessageString )
  subst 'monitoring/error-backup', 'short_error_message', shortMessageString
  subst 'monitoring/error-backup', 'extended_error_message', longMessageString
  return 'monitoring/error-backup'
end

def error_abort( shortMessageString, longMessageString )
  error_backup( shortMessageString, longMessageString )
  return 'monitoring/error-abort'
end

template( 'monitoring/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'monitoring/error-backup' ) do |question|
  question.template = 'monitoring/error'
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'monitoring/error-abort' => nil ) do |question|
  question.template = 'monitoring/error'
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'monitoring/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'monitoring �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ��������ɤǤ� monitoring �������Ԥ��ޤ���
  �����ǽ�ʹ��ܤϰʲ����̤�Ǥ���

   o Ganglia �����С�̾
   o gmetad �ݡ����ֹ�

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  DESCRIPTION_JA
end

question( 'monitoring/hello' => 'monitoring/server-name' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- �����С�̾����

template( 'monitoring/server-name' ) do |template|
  template.template_type = 'string'
  template.default = 'lucie.example.com' # FIXME: Ganglia �����С�̾�� Lucie �������
  template.short_description_ja = 'Ganglia �����С�̾'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Ganglia �����С�̾����ꤷ�Ƥ����������ǥե���ȤǤ� Lucie �����С���
  Ganglia �����С���Ʊ��ޥ���Ǥ���
  DESCRIPTION_JA
end

question( 'monitoring/server-name' =>
proc do |user_input|
  subst 'monitoring/confirmation', 'server-name', user_input
  'monitoring/port-number'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- �ݡ����ֹ�����

template( 'monitoring/port-number' ) do |template|
  template.template_type = 'string'
  template.default = '8651'
  template.short_description_ja = 'gmetad �ݡ����ֹ�'
  template.extended_description_ja = <<-DESCRIPTION_JA
  gmetad �Υݡ����ֹ����ꤷ�Ƥ���������
  DESCRIPTION_JA
end

question( 'monitoring/port-number' =>
proc do |user_input|
  if !(/\A\d+\Z/=~ user_input)
    error_backup( "���顼: �ݡ����ֹ����", "�ݡ����ֹ�η���������������ޤ��� : #{get('monitoring/port-number')}" )
  elsif  user_input.to_i <= 0 || user_input.to_i > 65535
    error_backup( "���顼: �ݡ����ֹ����", "�ݡ����ֹ���ϰϤ�����������ޤ��� : #{get('monitoring/port-number')}" )
  else
    subst 'monitoring/confirmation', 'port-number', user_input
    'monitoring/confirmation'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- �������γ�ǧ

template( 'monitoring/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '�������γ�ǧ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���������ǧ���ޤ���

   o Ganglia �����С�̾: ${server-name}
   o gmetad �ݡ����ֹ�: ${port-number}

  DESCRIPTION_JA
end

question( 'monitoring/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP �����.

spec = LMP::Specification.new do |spec|
  spec.name = "monitoring"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[�᥿�ѥå�����] monitoring'
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
