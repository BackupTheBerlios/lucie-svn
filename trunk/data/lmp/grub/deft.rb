#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/grub/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-grub setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of grub.

  DESCRIPTION

  template.short_description_ja = 'lmp-grub セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは grub の設定を Lucie サーバへ行います。

  DESCRIPTION_JA
end

question( 'lucie-client/grub/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
