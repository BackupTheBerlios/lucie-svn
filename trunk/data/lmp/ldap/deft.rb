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
  template.short_description_ja = 'LDAP の設定ウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate LDAP directory service configuration.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは LDAP ディレクトリサービスの設定を行います。
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
  template.short_description_ja = 'LDAP サーバの指定'
  template.extended_description = <<-DESCRIPTION
  Please enter the address of the LDAP server used.

  Note: It is usually a good idea to use an IP address; this reduces risks of failure int the event name service is unavailable.

  LDAP server host address

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  LDAP サーバのアドレスを入力してください。

  LDAP サーバのアドレス入力

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
  template.short_description_ja = 'search baseの指定'
  template.extended_description = <<-DESCRIPTION
  Please enter the distinguished name of the LDAP search base.  Many sites use the components of their domain names for this purpose.  For example, the domain "example.net" would use "dc=example,dc=net" as the distinguished name of the search base.

  distinguished name of the search base
   ( [Ex.] ${default_search} )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  LDAP search base のアドレスを分割して入力してください。例えば、ドメイン"example.net" は "dc=example,dc=net" と記述されます。

  LDAP search base アドレス (分割して記述)
   ( [例.] ${default_search} )
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
  template.short_description_ja = 'LDAP バージョンの選択'
  template.extended_description = <<-DESCRIPTION
  Please enter which version of the LDAP protocol ldapns is to use. It is usually a good idea to set this to highest available version number.

  LDAP version to use

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  用いる LDAP protocol ldapns を入力してください。

  用いる LDAP のバージョン

  DESCRIPTION_JA
end

question( 'lucie-client/ldap/version' => 'lucie-client/ldap/secret' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/secret' ) do |template|
  template.template_type = 'password'
  template.short_description = 'configure ldap.secret'
  template.short_description_ja = 'ldap.secret の設定'
  template.extended_description = <<-DESCRIPTION
  Please input your ldap.secret password. (Maybe /etc/ldap.secret in your LDAP server)
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  ldap.secret のパスワードを入力してください。 (LDAP サーバの /etc/ldap.secret の内容)
  DESCRIPTION_JA
end

question( 'lucie-client/ldap/secret' => 'lucie-client/ldap/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/ldap/bye' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Note'
  template.short_description_ja = '注意'
  template.extended_description = <<-DESCRIPTION
  Configure files shown below by means of making a script depending on each environment.

   o /etc/libnss-ldap.conf
   o /etc/pam_ldap.conf

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  各環境に合わせて、script などによって以下のファイルを修正してください。

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
