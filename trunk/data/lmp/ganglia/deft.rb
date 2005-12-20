#
# $Id: deft.rb 924 2005-09-30 07:10:37Z takamiya $
#
# Author::   Hideo NISHIMURA (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 924 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/ganglia/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-ganglia setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of ganglia.
  DESCRIPTION
  template.short_description_ja = 'lmp-ganglia ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ᥿�ѥå������� ganglia ������� Lucie �����ФعԤ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-client/ganglia/hello' => 'lucie-client/ganglia/trusted_hosts' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Trusted Hosts ������

template( 'lucie-client/ganglia/trusted_hosts' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'Ganglia �����Ф�����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Ganglia �ξ���������륵���ФΥ��ɥ쥹�򡢥��ڡ����Ƕ��ڤä����Ϥ��Ƥ���������
  (��: 192.168.1.1 ganglia.cluster.org)

  Ganglia �ˤ�����򡢾嵭�Υ����з�ͳ�����뤳�Ȥ�����ޤ���
  DESCRIPTION_JA
end

question( 'lucie-client/ganglia/trusted_hosts' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
