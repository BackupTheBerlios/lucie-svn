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
  subst 'mpi/error-backup', 'short_error_message', shortMessageString
  subst 'mpi/error-backup', 'extended_error_message', longMessageString
  return 'mpi/error-backup'
end

def error_abort( shortMessageString, longMessageString )
  error_backup( shortMessageString, longMessageString )
  return 'mpi/error-abort'
end

template( 'mpi/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'mpi/error-backup' ) do |question|
  question.template = 'mpi/error'
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'mpi/error-abort' => nil ) do |question|
  question.template = 'mpi/error'
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'mpi/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'MPI のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは MPI の設定を行います。
  設定可能な項目は以下の通りです。

   o インストールする MPI の選択（MPICH, LAM）
   o machines ファイルの生成

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'mpi/hello' => 'mpi/select-mpi' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- 

template( 'mpi/select-mpi' ) do |template|
  template.template_type = 'select'
  template.choices = 'mpich, lam'
  template.short_description_ja = 'MPI の選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  インストールする MPI を選択してください
  DESCRIPTION_JA
end

question( 'mpi/select-mpi' =>
proc do |user_input|
  subst 'mpi/confirmation', 'mpi-flavor', user_input
  'mpi/machines-file' 
end  ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'mpi/machines-file' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'Machines ファイルの生成'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Machines ファイルを生成しますか？
  DESCRIPTION_JA
end

question( 'mpi/machines-file' =>
proc do |user_input|
  if user_input == 'true'
    case get('mpi/select-mpi')
    when 'mpich'
        subst 'mpi/confirmation', 'machines-file', 'mpich-machines'
# FIXME: mpich の machines ファイルを Lucie サーバーから生成。上記の machines ファイルも要修正
    when 'lam'
        subst 'mpi/confirmation', 'machines-file', 'lam-machines'
# FIXME: lam の machines ファイルを Lucie サーバーから生成。上記の machines ファイルも要修正
    else
        # not reached here
        subst 'mpi/confirmation', 'machines-file', 'Unknown MPI Flavor'
    end
  else
    subst 'mpi/confirmation', 'machines-file', user_input
  end
  'mpi/confirmation' 
end  ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 設定情報の確認

template( 'mpi/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。

   o インストールする MPI: ${mpi-flavor}
   o machines ファイルの生成: ${machines-file}
  DESCRIPTION_JA
end

question( 'mpi/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "mpi"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yoshiaki Sakae <sakae@is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] MPI'
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
