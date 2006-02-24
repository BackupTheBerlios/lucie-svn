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
  template.short_description = 'Welcome to lmp-mpi setup wizard.'
  template.short_description_ja = 'MPI のセットアップウィザードへようこそ'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate MPI configuration for lucie.

  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは MPI の設定を行います。

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
  template.short_description = 'Choose MPI'
  template.short_description_ja = 'MPI の選択'
  template.extended_description = <<-DESCRIPTION
  Choose MPI package to be installed.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  インストールする MPI を選択してください
  DESCRIPTION_JA
end

question( 'lucie-client/mpi/select-mpi' => nil ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
