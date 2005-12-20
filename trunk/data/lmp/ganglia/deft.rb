#
# $Id: deft.rb 924 2005-09-30 07:10:37Z takamiya $
#
# Author::   Hideo NISHIMURA (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 924 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/ganglia/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-ganglia setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of ganglia.
  DESCRIPTION
  template.short_description_ja = 'lmp-ganglia セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは ganglia の設定を Lucie サーバへ行います。
  DESCRIPTION_JA
end

question( 'lucie-client/ganglia/hello' => 'lucie-client/ganglia/trusted_hosts' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Trusted Hosts の入力

template( 'lucie-client/ganglia/trusted_hosts' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'Ganglia サーバの設定'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Ganglia の情報を受け取るサーバのアドレスを、スペースで区切って入力してください。
  (例: 192.168.1.1 ganglia.cluster.org)

  Ganglia による情報を、上記のサーバ経由で得ることが出来ます。
  DESCRIPTION_JA
end

question( 'lucie-client/ganglia/trusted_hosts' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
