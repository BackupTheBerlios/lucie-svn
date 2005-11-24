#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo NISHIMURA (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/hello/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-hello setup wizard.'
  template.short_description_ja = 'lmp-hello セットアップウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of hello.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは hello の設定を Lucie サーバへ行います
  DESCRIPTION_JA
end

question( 'lucie-client/hello/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
