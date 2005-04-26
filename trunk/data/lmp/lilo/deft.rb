#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/lilo/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-lilo setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup lilo configuration.
  DESCRIPTION
end

question( 'lucie-client/lilo/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
