#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# ------------------------- 

template( 'lucie-client/xen/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'Xen のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは Xen 3.0.0 の設定を行います。

  このパッケージをインストールするためには lmp-grub が必要です。

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'lucie-client/xen/hello' => 'lucie-client/xen/memory' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/xen/memory' ) do |template|
  template.template_type = 'string'
  template.default = '131072'
  template.short_description_ja = 'Xen Domain0 メモリ量の設定'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Xen Domain0 に割り当てるメモリ量を入力してください。(単位: kbytes)
  DESCRIPTION_JA
end

question( 'lucie-client/xen/memory' => 'lucie-client/xen/kernel' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/kernel' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'Kernel の選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  起動されるカーネルを Xen0 カーネルにしますか？
  DESCRIPTION_JA
end

question( 'lucie-client/xen/kernel' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
