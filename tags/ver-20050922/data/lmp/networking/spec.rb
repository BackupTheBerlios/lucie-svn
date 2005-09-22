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
  subst 'networking/error-backup', 'short_error_message', shortMessageString
  subst 'networking/error-backup', 'extended_error_message', longMessageString
  return 'networking/error-backup'
end

def error_abort( shortMessageString, longMessageString )
  error_backup( shortMessageString, longMessageString )
  return 'networking/error-abort'
end

template( 'networking/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'networking/error-backup' ) do |question|
  question.template = 'networking/error'
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'networking/error-abort' => nil ) do |question|
  question.template = 'networking/error'
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '�ͥåȥ���Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ��������ɤǤϥͥåȥ���������Ԥ��ޤ���
  �����ǽ�ʹ��ܤϰʲ����̤�Ǥ���

   o Lucie �����С��������
   o DHCP ���饤�����
   o ��ư����

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  DESCRIPTION_JA
end

question( 'networking/hello' => 'networking/from-lucie' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'networking/from-lucie' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = '�ͥåȥ������� Lucie �����С�����������ޤ�����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ͥåȥ������� Lucie �����С�����������ޤ�����
  DESCRIPTION_JA
end

question( 'networking/from-lucie' =>
proc do |user_input|
  if user_input == 'true'
    subst 'networking/confirmation', 'dhcp-enabled',  'false'
    'networking/confirmation'
# FIXME: true ���ˤ� Lucie �����С����������������� confirmation ����������ɽ������褦��
  else
    'networking/use-dhcp'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'networking/use-dhcp' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = '�ͥåȥ��������� DHCP �����Ѥ��ޤ�����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ͥåȥ��������� DHCP �����Ѥ��ޤ�����
  DESCRIPTION_JA
end

question( 'networking/use-dhcp' =>
proc do |user_input|
  subst 'networking/confirmation', 'dhcp-enabled',  user_input
  if user_input == 'true'
    'networking/confirmation'
  else
    'networking/ip-address'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/ip-address' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'IP ���ɥ쥹'
  template.extended_description_ja = <<-DESCRIPTION_JA
  IP ���ɥ쥹�����Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/ip-address' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "���顼: IP ���ɥ쥹����", "IP ���ɥ쥹�η���������������ޤ��� : #{get('networking/ip-address')}" )
  else
    subst 'networking/confirmation', 'ip-address', user_input 
    'networking/netmask'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/netmask' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = '�ͥåȥޥ���'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ͥåȥޥ��������Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/netmask' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "���顼: �ͥåȥޥ�������", "�ͥåȥޥ����η���������������ޤ��� : #{get('networking/netmask')}" )
  else
    subst 'networking/confirmation', 'netmask', user_input 
    'networking/hostname'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/hostname' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = '�ۥ���̾'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ۥ���̾�����Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/hostname' =>
proc do |user_input|
  subst 'networking/confirmation', 'hostname', user_input 
  'networking/default-route'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/default-route' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = '�ǥե���ȥ롼��'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ǥե���ȥ롼�Ȥ� IP ���ɥ쥹�����Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/default-route' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "���顼: IP ���ɥ쥹����", "IP ���ɥ쥹�η���������������ޤ��� : #{get('networking/default-route')}" )
  else
    subst 'networking/confirmation', 'default-route', user_input 
    'networking/nis-domain'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/nis-domain' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'NIS �ɥᥤ��'
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS �ɥᥤ������Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/nis-domain' =>
proc do |user_input|
  subst 'networking/confirmation', 'nis-domain', user_input 
  'networking/nis-server'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/nis-server' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'NIS �����С�'
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS �����С��� IP ���ɥ쥹�����Ϥ��Ƥ�������
  DESCRIPTION_JA
end

question( 'networking/nis-server' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "���顼: IP ���ɥ쥹����", "IP ���ɥ쥹�η���������������ޤ��� : #{get('networking/nis-server')}" )
  else
    subst 'networking/confirmation', 'nis-server', user_input 
    'networking/confirmation'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- �������γ�ǧ

template( 'networking/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '�������γ�ǧ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���������ǧ���ޤ���

   o DHCP enabled?: ${dhcp-enabled}
   o IP address: ${ip-address}
   o Netmask: ${netmask}
   o Host Name: ${hostname}
   o Default Route: ${default-route}
   o NIS Domain: ${nis-domain}
   o NIS Server: ${nis-server}
  DESCRIPTION_JA
end

question( 'networking/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP �����.

spec = LMP::Specification.new do |spec|
  spec.name = "networking"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[�᥿�ѥå�����] networking'
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
