#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/compile/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-compile setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup packages for developing software.
  DESCRIPTION
end

question( 'lucie-client/compile/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
