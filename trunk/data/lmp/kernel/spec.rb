#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

template( 'kernel/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'kernel のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは kernel の設定を行います。
  設定可能な項目は以下の通りです。

   o インストールするカーネルのバージョン

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'kernel/hello' => 'kernel/kernel-version' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- カーネルバージョン選択
template( 'kernel/kernel-version' ) do |template|
  template.template_type = 'select'
  template.choices = '2.4.22, 2.6.0, 2.2.0'
  template.short_description_ja = 'インストールするカーネルのバージョン'
  template.extended_description_ja = <<-DESCRIPTION_JA
  インストールするカーネルのバージョンを選んでください。
  DESCRIPTION_JA
end

question( 'kernel/kernel-version' =>
proc do |user_input|
  subst 'kernel/confirmation', 'kernel-version', user_input
  'kernel/confirmation'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 設定情報の確認

template( 'kernel/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。

   o カーネルバージョン: ${kernel-version}

  DESCRIPTION_JA
end

question( 'kernel/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "kernel"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] kernel'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
  Included packages:

   o FIXME

  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'test/lmp/build'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
