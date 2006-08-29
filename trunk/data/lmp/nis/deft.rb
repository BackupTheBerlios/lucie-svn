#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# -------------------------

template( 'lucie-client/nis/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-nis setup wizard'
  template.short_description_ja = 'NIS メタパッケージの設定ウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate NIS (Network Information Service) configuration.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定ウィザードは NIS (Network Information Service) の設定を行います。
  DESCRIPTION_JA
end

question( 'lucie-client/nis/hello' => 'lucie-client/nis/domain' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/nis/domain' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure default domain'
  template.short_description_ja = 'デフォルトドメインの設定'
  template.extended_description = <<-DESCRIPTION
  Please input your NIS default domain.

  ( [Ex.] cluster_nis )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS のデフォルトドメインを入力して下さい。
  
  ( [例.] cluster_nis )
  DESCRIPTION_JA
end

question( 'lucie-client/nis/domain' => 'lucie-client/nis/question' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/nis/question' ) do |template|
  template.template_type = 'boolean'
  template.default = 'false'
  template.short_description = 'Is your NIS server not local?'
  template.short_description_ja = 'NIS サーバは複数存在しますか？'
  template.extended_description = <<-DESCRIPTION
  Is your NIS server not "local" to your network?
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NISサーバはローカルネットワーク内に複数存在しますか?
  DESCRIPTION_JA
end

question( 'lucie-client/nis/question' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true' => 'lucie-client/nis/server' }
end

# -------------------------

template( 'lucie-client/nis/server' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Hardcore NIS Server'
  template.short_description_ja = 'NIS サーバの固定'
  template.extended_description = <<-DESCRIPTION
  Please input your NIS server address to hardcore a NIS server there.

  ( [Ex.] 192.168.1.2 )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS サーバを固定するために、NIS サーバのアドレスを入力して下さい。
  
  ( [例.] 192.168.1.2 )
  DESCRIPTION_JA
end

question( 'lucie-client/nis/server' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: