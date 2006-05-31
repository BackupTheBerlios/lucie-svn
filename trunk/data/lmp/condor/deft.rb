#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/condor/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-condor setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of condor.
  DESCRIPTION
  template.short_description_ja = 'lmp-condor セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは condor の設定を Lucie サーバへ行います。
  DESCRIPTION_JA
end

question( 'lucie-client/condor/hello' => 'lucie-client/condor/central_manager' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Central Manager の入力 

template( 'lucie-client/condor/central_manager' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'Condor セントラルマネージャの設定'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Condor セントラルマネージャを動作させるノードのアドレスを入力してください。
  
  (例: central.manager.net OR 123.456.789.0 )

  ジョブをサブミットする際には,このセントラルマネージャを経由して行われます。
  DESCRIPTION_JA
end

question( 'lucie-client/condor/central_manager' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
