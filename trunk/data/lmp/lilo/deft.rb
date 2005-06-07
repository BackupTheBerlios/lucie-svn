#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/lilo/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-lilo setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of lilo.

  NOTE: Lucie lilo script provided by this package may fail because of
  the lack of necessary libdevmapper shared library in nfsroot. In
  this case, please add libdevmapper1.01 (or 1.00) to the
  installer.extra_packages in /etc/lucie/resource.rb and re-run
  lucie-setup
  DESCRIPTION
  template.short_description_ja = 'lmp-lilo ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ᥿�ѥå������� lilo ������� Lucie �����ФعԤ��ޤ���

  ���: ���Υ᥿�ѥå������ˤ�ä��󶡤���� Lucie ������ץȤϡ�
  nfsroot ���ɬ�פ� libdevmapper ��ͭ�饤�֥�꤬���󥹥ȡ��뤵��Ƥ�
  �ʤ�����˼��Ԥ����礬����ޤ������ξ�硢/etc/lucie/resource.rb 
  �� installer.extra_packages �� libdevmapper1.01 (�⤷���� 1.00) ����
  �ä���lucie-setup ��Ƽ¹Ԥ��Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-client/lilo/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
