#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# ------------------------- 

template( 'lucie-client/mpi/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'MPI のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは MPI の設定を行います。
  設定可能な項目は以下の通りです。

   o インストールする MPI の選択（MPICH, MPICH-MPD, LAM）
   o machines ファイルの生成

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'lucie-client/mpi/hello' => 'lucie-client/mpi/select-mpi' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- 

template( 'lucie-client/mpi/select-mpi' ) do |template|
  template.template_type = 'select'
  template.choices = 'MPICH, MPICH-MPD, LAM'
  template.short_description_ja = 'MPI の選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  インストールする MPI を選択してください
  DESCRIPTION_JA
end

question( 'lucie-client/mpi/select-mpi' =>
proc do |user_input|
  subst 'lucie-client/mpi/confirmation', 'mpi_flavor', user_input
  'lucie-client/mpi/machines-file' 
end  ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 

template( 'lucie-client/mpi/machines-file' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'Machines ファイルの生成'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Lucie ホストグループのクライアントからなる Machines ファイルを生成しますか？
  DESCRIPTION_JA
end

question( 'lucie-client/mpi/machines-file' =>
proc do |user_input|
  if user_input == 'true'
    case get('lucie-client/mpi/select-mpi')
    when 'MPICH'
        subst 'lucie-client/mpi/confirmation', 'machines-file', 'machines.LINUX (MPICH)'
    when 'MPICH-MPD'
        subst 'lucie-client/mpi/confirmation', 'machines-file', 'machines.LINUX (MPICH-MPD)'
    when 'LAM'
        subst 'lucie-client/mpi/confirmation', 'machines-file', 'bhost.def (LAM)'
    else
        # not reached here
        subst 'lucie-client/mpi/confirmation', 'machines-file', 'Unknown MPI Flavor'
    end
  else
    subst 'lucie-client/mpi/confirmation', 'machines-file', '生成しない'
  end
  'lucie-client/mpi/confirmation' 
end  ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- 設定情報の確認

template( 'lucie-client/mpi/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。

   o インストールする MPI: ${mpi_flavor}
   o Machines ファイルの生成: ${machines-file}
  DESCRIPTION_JA
end

question( 'lucie-client/mpi/confirmation' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
