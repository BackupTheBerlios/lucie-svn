#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# ------------------------- エラー表示用テンプレート/質問 

def error_backup( shortMessageString, longMessageString )
  subst 'monitoring/error-backup', 'short_error_message', shortMessageString
  subst 'monitoring/error-backup', 'extended_error_message', longMessageString
  return 'monitoring/error-backup'
end

def error_abort( shortMessageString, longMessageString )
  error_backup( shortMessageString, longMessageString )
  return 'monitoring/error-abort'
end

template( 'monitoring/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'monitoring/error-backup' ) do |question|
  question.template = 'monitoring/error'
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'monitoring/error-abort' => nil ) do |question|
  question.template = 'monitoring/error'
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'monitoring/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'monitoring のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは monitoring の設定を行います。
  設定可能な項目は以下の通りです。

   o Ganglia サーバー名
   o gmetad ポート番号

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'monitoring/hello' => 'monitoring/server-name' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- サーバー名設定

template( 'monitoring/server-name' ) do |template|
  template.template_type = 'string'
  template.default = 'lucie.example.com' # FIXME: Ganglia サーバー名を Lucie から取得
  template.short_description_ja = 'Ganglia サーバー名'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Ganglia サーバー名を指定してください。デフォルトでは Lucie サーバーと
  Ganglia サーバーは同一マシンです。
  DESCRIPTION_JA
end

question( 'monitoring/server-name' =>
proc do |user_input|
  subst 'monitoring/confirmation', 'server-name', user_input
  'monitoring/port-number'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- ポート番号設定

template( 'monitoring/port-number' ) do |template|
  template.template_type = 'string'
  template.default = '8651'
  template.short_description_ja = 'gmetad ポート番号'
  template.extended_description_ja = <<-DESCRIPTION_JA
  gmetad のポート番号を指定してください。
  DESCRIPTION_JA
end

question( 'monitoring/port-number' =>
proc do |user_input|
  if !(/\A\d+\Z/=~ user_input)
    error_backup( "エラー: ポート番号形式", "ポート番号の形式が正しくありません : #{get('monitoring/port-number')}" )
  elsif  user_input.to_i <= 0 || user_input.to_i > 65535
    error_backup( "エラー: ポート番号形式", "ポート番号の範囲が正しくありません : #{get('monitoring/port-number')}" )
  else
    subst 'monitoring/confirmation', 'port-number', user_input
    'monitoring/confirmation'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 設定情報の確認

template( 'monitoring/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。

   o Ganglia サーバー名: ${server-name}
   o gmetad ポート番号: ${port-number}

  DESCRIPTION_JA
end

question( 'monitoring/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "monitoring"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] monitoring'
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
