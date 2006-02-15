#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# -------------------------

template( 'lucie-client/ldap/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-ldap setup wizard'
  template.short_description_ja = 'LDAP �̐ݒ�E�B�U�[�h�ւ悤����'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate LDAP directory service configuration.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���̃E�B�U�[�h�ł� LDAP �f�B���N�g���T�[�r�X�̐ݒ���s���܂��B
  DESCRIPTION_JA
end

question( 'lucie-client/ldap/hello' => 'lucie-client/ldap/server' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/ldap/server' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure LDAP Server'
  template.short_description_ja = 'LDAP �T�[�o�̎w��'
  template.extended_description = <<-DESCRIPTION
  Please enter the address of the LDAP server used.

  Note: It is usually a good idea to use an IP address; this reduces risks of failure int the event name service is unavailable.

  LDAP server host address

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  LDAP �T�[�o�̃A�h���X����͂��Ă��������B

  LDAP �T�[�o�̃A�h���X����

  DESCRIPTION_JA
end

question( 'lucie-client/ldap/server' =>
proc do |user_input|
   search_base = "dc=" << (user_input.split('.')).join(",dc=")
   subst 'lucie-client/ldap/search', 'default_search', "#{search_base}"
   'lucie-client/ldap/search'
end  ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/search' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configuring search base'
  template.short_description_ja = 'search base�̎w��'
  template.extended_description = <<-DESCRIPTION
  Please enter the distinguished name of the LDAP search base.  Many sites use the components of their domain names for this purpose.  For example, the domain "example.net" would use "dc=example,dc=net" as the distinguished name of the search base.

  distinguished name of the search base
   ( [Ex.] ${default_search} )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  LDAP search base �̃A�h���X�𕪊����ē��͂��Ă��������B�Ⴆ�΁A�h���C��"example.net" �� "dc=example,dc=net" �ƋL�q����܂��B

  LDAP search base �A�h���X (�������ċL�q)
   ( [��.] ${default_search} )
  DESCRIPTION_JA
end

question( 'lucie-client/ldap/search' => 'lucie-client/ldap/version' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/version' ) do |template|
  template.template_type = 'select'
  template.choices = ['3', '2']
  template.short_description = 'Select LDAP version'
  template.short_description_ja = 'LDAP �o�[�W�����̑I��'
  template.extended_description = <<-DESCRIPTION
  Please enter which version of the LDAP protocol ldapns is to use. It is usually a good idea to set this to highest available version number.

  LDAP version to use

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �p���� LDAP protocol ldapns ����͂��Ă��������B

  �p���� LDAP �̃o�[�W����

  DESCRIPTION_JA
end

question( 'lucie-client/ldap/version' => 'lucie-client/ldap/secret' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/secret' ) do |template|
  template.template_type = 'password'
  template.short_description = 'configure ldap.secret'
  template.short_description_ja = 'ldap.secret �̐ݒ�'
  template.extended_description = <<-DESCRIPTION
  Please input your ldap.secret password. (Maybe /etc/ldap.secret in your LDAP server)
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  ldap.secret �̃p�X���[�h����͂��Ă��������B (LDAP �T�[�o�� /etc/ldap.secret �̓��e)
  DESCRIPTION_JA
end

question( 'lucie-client/ldap/secret' => 'lucie-client/ldap/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/bye' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Note'
  template.short_description_ja = '����'
  template.extended_description = <<-DESCRIPTION
  Configure files shown below by means of making a script depending on each environment.

   o /etc/libnss-ldap.conf
   o /etc/pam_ldap.conf

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �e���ɍ��킹�āAscript �Ȃǂɂ���Ĉȉ��̃t�@�C�����C�����Ă��������B

   o /etc/libnss-ldap.conf
   o /etc/pam_ldap.conf

  DESCRIPTION_JA
end

question( 'lucie-client/ldap/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
