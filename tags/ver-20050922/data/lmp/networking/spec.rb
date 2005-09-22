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
  subst 'networking/error-backup', 'short_error_message', shortMessageString
  subst 'networking/error-backup', 'extended_error_message', longMessageString
  return 'networking/error-backup'
end

def error_abort( shortMessageString, longMessageString )
  error_backup( shortMessageString, longMessageString )
  return 'networking/error-abort'
end

template( 'networking/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'networking/error-backup' ) do |question|
  question.template = 'networking/error'
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'networking/error-abort' => nil ) do |question|
  question.template = 'networking/error'
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'ネットワークのセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードではネットワークの設定を行います。
  選択可能な項目は以下の通りです。

   o Lucie サーバーから取得
   o DHCP クライアント
   o 手動設定

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'networking/hello' => 'networking/from-lucie' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'networking/from-lucie' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'ネットワーク情報を Lucie サーバーから取得しますか？'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ネットワーク情報を Lucie サーバーから取得しますか？
  DESCRIPTION_JA
end

question( 'networking/from-lucie' =>
proc do |user_input|
  if user_input == 'true'
    subst 'networking/confirmation', 'dhcp-enabled',  'false'
    'networking/confirmation'
# FIXME: true 時には Lucie サーバーから取得した情報を confirmation ダイアログで表示するように
  else
    'networking/use-dhcp'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'networking/use-dhcp' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'ネットワークの設定に DHCP を利用しますか？'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ネットワークの設定に DHCP を利用しますか？
  DESCRIPTION_JA
end

question( 'networking/use-dhcp' =>
proc do |user_input|
  subst 'networking/confirmation', 'dhcp-enabled',  user_input
  if user_input == 'true'
    'networking/confirmation'
  else
    'networking/ip-address'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/ip-address' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'IP アドレス'
  template.extended_description_ja = <<-DESCRIPTION_JA
  IP アドレスを入力してください
  DESCRIPTION_JA
end

question( 'networking/ip-address' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "エラー: IP アドレス形式", "IP アドレスの形式が正しくありません : #{get('networking/ip-address')}" )
  else
    subst 'networking/confirmation', 'ip-address', user_input 
    'networking/netmask'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/netmask' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'ネットマスク'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ネットマスクを入力してください
  DESCRIPTION_JA
end

question( 'networking/netmask' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "エラー: ネットマスク形式", "ネットマスクの形式が正しくありません : #{get('networking/netmask')}" )
  else
    subst 'networking/confirmation', 'netmask', user_input 
    'networking/hostname'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/hostname' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'ホスト名'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ホスト名を入力してください
  DESCRIPTION_JA
end

question( 'networking/hostname' =>
proc do |user_input|
  subst 'networking/confirmation', 'hostname', user_input 
  'networking/default-route'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/default-route' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'デフォルトルート'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトルートの IP アドレスを入力してください
  DESCRIPTION_JA
end

question( 'networking/default-route' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "エラー: IP アドレス形式", "IP アドレスの形式が正しくありません : #{get('networking/default-route')}" )
  else
    subst 'networking/confirmation', 'default-route', user_input 
    'networking/nis-domain'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/nis-domain' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'NIS ドメイン'
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS ドメインを入力してください
  DESCRIPTION_JA
end

question( 'networking/nis-domain' =>
proc do |user_input|
  subst 'networking/confirmation', 'nis-domain', user_input 
  'networking/nis-server'
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'networking/nis-server' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'NIS サーバー'
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS サーバーの IP アドレスを入力してください
  DESCRIPTION_JA
end

question( 'networking/nis-server' =>
proc do |user_input|
  unless /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/=~ user_input
    error_backup( "エラー: IP アドレス形式", "IP アドレスの形式が正しくありません : #{get('networking/nis-server')}" )
  else
    subst 'networking/confirmation', 'nis-server', user_input 
    'networking/confirmation'
  end
end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 設定情報の確認

template( 'networking/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。

   o DHCP enabled?: ${dhcp-enabled}
   o IP address: ${ip-address}
   o Netmask: ${netmask}
   o Host Name: ${hostname}
   o Default Route: ${default-route}
   o NIS Domain: ${nis-domain}
   o NIS Server: ${nis-server}
  DESCRIPTION_JA
end

question( 'networking/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "networking"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] networking'
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
