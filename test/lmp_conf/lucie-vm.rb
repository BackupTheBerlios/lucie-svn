#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie'

include Lucie

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = Template::NOTE
  template.description = (<<-DESCRIPTION)
Hello!
Welcome to Lucie VM setup wizard.
  DESCRIPTION
  template.description_ja = (<<-DESCRIPTION_JA)
こんにちは
Lucie VM のセットアップウィザードへようこそ
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
VM ノード台数の選択です
使用したい VM の台数を入れてください
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = Template::BOOLEAN
  template.default = 'no'
  template.description_ja = (<<-DESCRIPTION_JA)
ノードのネットワーク
ノードはネットワークにつながりますか？
  DESCRIPTION_JA
end.register

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
