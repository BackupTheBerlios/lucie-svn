#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/network/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-network setup wizard.'
  template.short_description_ja = 'lmp-network セットアップウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of networking.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージはネットワーク設定を Lucie サーバへ行います
  DESCRIPTION_JA
end

question( 'lucie-client/network/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
