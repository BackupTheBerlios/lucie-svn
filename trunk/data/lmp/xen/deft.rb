#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
require 'lucie/installer'
include Deft
include Lucie::Installer

# ------------------------- 

template( 'lucie-client/xen/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-xen setup wizard'
  template.short_description_ja = 'Xen のセットアップウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup Xen VMM.

  This package require Xen binary installer (tar ball) which includes "install.sh".

  This package require lmp-grub metapackage.

  DESCRIPTION

  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは Xen の設定を行います。

  このパッケージをインストールするためには、install.sh を含んだ Xen のバイナリインストーラ(tar ball)が必要です。

  このパッケージをインストールするためには lmp-grub が必要です。

  DESCRIPTION_JA
end

question( 'lucie-client/xen/hello' =>
proc do
  subst 'lucie-client/xen/bye', 'installer_name', "#{installer_resource.name}"
  'lucie-client/xen/memory' 
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/xen/memory' ) do |template|
  template.template_type = 'string'
  template.default = '131072'
  template.short_description = 'Configure memory amount'
  template.short_description_ja = 'メモリ量の設定'
  template.extended_description = <<-DESCRIPTION
  Please enter an amount of memory size used by Xen Domain0. (kbytes)
  DESCRIPTION
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
  template.short_description = 'Select Kernel'
  template.short_description_ja = 'Kernel の選択'
  template.extended_description = <<-DESCRIPTION
  Make Xen0 first boot kernel ?
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  起動されるカーネルを Xen0 カーネルにしますか？
  DESCRIPTION_JA
end

question( 'lucie-client/xen/kernel' => 'lucie-client/xen/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/xen/bye' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Important!'
  template.short_description_ja = '重要！'
  template.extended_description = <<-DESCRIPTION
  Put Xen binary installer tar ball as 
  /var/lib/lucie/nfsroot/${installer_name}/tmp/xen.tgz ]
  and then, click ok.
  
  (If not, install cannot be completed.)
  (You must put xen.tgz each time you install lmp-xen)

  Note: This tar ball must include Xen intaller (install.sh)
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  Xen のバイナリインストーラ tar ball を 
  /var/lib/lucie/nfsroot/${installer_name}/tmp/xen.tgz
  として置いてあるのを確認し、OK を選択してください。

  (xen.tgz がないとインストールは続行出来ません。)
  (xen.tgz は lmp-xen のインストール時には毎回置く必要があります。)

  注: tar ball は Xen インストーラ (install.sh) を含んでいる必要があります。
  DESCRIPTION_JA
end

question( 'lucie-client/xen/bye' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
