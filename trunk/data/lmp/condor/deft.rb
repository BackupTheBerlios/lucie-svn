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

question( 'lucie-client/condor/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
