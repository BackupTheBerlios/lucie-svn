#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/condor/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-condor setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of condor.
  DESCRIPTION
  template.short_description_ja = 'lmp-condor ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ᥿�ѥå������� condor ������� Lucie �����ФعԤ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-client/condor/hello' => 'lucie-client/condor/central_manager' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Central Manager ������

template( 'lucie-client/condor/central_manager' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'Condor ����ȥ��ޥ͡����������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Condor ����ȥ��ޥ͡������ư����륯�饹���Ρ���̾�����Ϥ��Ƥ���������
  
  (��: condor_central_manager)

  ����֤򥵥֥ߥåȤ���ݤˤ�,���Υ���ȥ��ޥ͡�������ͳ���ƹԤ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-client/condor/central_manager' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
