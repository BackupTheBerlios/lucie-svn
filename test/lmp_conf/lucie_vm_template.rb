#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'

include Deft

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = NoteTemplate
  template.short_description = 'Hello!'
  template.extended_description = 'Welcome to Lucie VM setup wizard.'
  template.short_description_ja = 'こんにちは'
  template.extended_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
end

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = 'VM ノード台数の選択です'
  template.extended_description_ja = '使用したい VM の台数を入れてください'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = 'ノードのネットワーク'
  template.extended_description_ja = 'ノードはネットワークにつながりますか？'
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = 'ノードの ip アドレス'
  template.extended_description_ja = 'ノードの IP アドレスは？'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = 'ノードのメモリ容量'
  template.extended_description_ja = '使用したいメモリ容量を入力してください (単位: MB)'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = StringTemplate
  template.short_description_ja = 'ノードのハードディスク容量'
  template.extended_description_ja = '使用したいハードディスク容量を入れてください (単位: MB)'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'umlinux', 'colinux', 'vmware']
  template.short_description_ja = '使用する VM の種類'
  template.extended_description_ja = '使用する VM を選択してください'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '使用するディストリビューションの選択'
  template.extended_description_ja = '使用するディストリビューションを選択してください'
end

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = MultiselectTemplate
  template.choices = ['ruby', 'perl', 'java']
  template.short_description_ja = '使用するアプリケーションの選択'
  template.extended_description_ja = '使用するアプリケーションを選択してください'
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
