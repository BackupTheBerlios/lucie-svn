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

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
