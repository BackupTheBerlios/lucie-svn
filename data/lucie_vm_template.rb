#
# $Id: lucie_vm_template.rb 106 2005-02-11 14:03:23Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 106 $
# License::  GPL2

$KCODE = 'EUCJP'
require 'lucie'

include Lucie

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  このウィザードでは、Lucie を用いた VM セットアップの設定を入力します。
  設定可能な項目は、
   o 必要な VM の台数
   o 外部ネットワークへの接続
   o VM で使用するメモリ容量
   o VM で使用するハードディスク容量
   o 使用する VM の種類
   o VM へインストールする Linux ディストリビューションの種類
   o VM へインストールするソフトウェアの種類
  です。自分が VM 上で走らせたいジョブの特性によって設定を決めてください。

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/num-nodes'
  question.first_question = true
end

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['4', '8', '12', '16', '20', '24', '28', '32', '36', '40', '44', '48', '52', '56', '60', '64']
  template.short_description_ja = 'VM ノードの台数'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM の台数を選択してください。

  松岡研 PrestoIII クラスタで提供できる VM クラスタのノード数は、4 台～ 64 台となっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要な台数を選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/use-network'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = 'VM の外部ネットワークへの接続'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ジョブ実行時に VM は外部ネットワークへ接続する必要がありますか？
  このオプションをオンにすると、GRAM が自動的に各 VM に連続した IP アドレスと MAC アドレスを割り当て、
  Lucie をすべてのネットワーク関係の設定を行います。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'VM の IP アドレス'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  以下のようにホスト名、IP アドレス、MAC アドレスを割り振りました。
  使用可能な VM は pad000 - pad003 の 4 ノードです。
  
   ホスト名: pad000
   IP アドレス: 168.220.98.30
   MAC アドレス: 00:50:56:01:02:02

   ホスト名: pad001
   IP アドレス: 163.220.98.31
   MAC アドレス: 00:50:56:01:02:03

   ホスト名: pad002
   IP アドレス: 163.220.98.32
   MAC アドレス: 00:50:56:01:02:04

   ホスト名: pad003
   IP アドレス: 163.220.98.33
   MAC アドレス: 00:50:56:01:02:05
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
  template.short_description_ja = 'VM ノードのメモリ容量'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM 一台あたりのメモリ容量を選択してください。単位は MB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのメモリ容量は 640 MB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なメモリ容量を選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['1', '2', '3', '4']
  template.short_description_ja = 'VM ノードのハードディスク容量'  
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM 一台あたりのハードディスク容量を選択してください。単位は GB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのハードディスク容量は 4GB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なハードディスク容量を選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'umlinux', 'colinux', 'vmware']
  template.short_description_ja = '使用する VM の種類'
  template.extended_description_ja = '使用する VM を選択してください'
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '使用するディストリビューションの選択'
  template.extended_description_ja = '使用するディストリビューションを選択してください'
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/application'
end

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = MultiselectTemplate
  template.choices = ['ruby', 'perl', 'java']
  template.short_description_ja = '使用するアプリケーションの選択'
  template.extended_description_ja = '使用するアプリケーションを選択してください'
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
