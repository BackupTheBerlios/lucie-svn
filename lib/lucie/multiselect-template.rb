#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'

require 'lucie/template'
require 'lucie/time-stamp'

module Lucie
  
  update(%q$LastChangedDate$)
  
  # multiselect �^�C�v�� Template ������킷�N���X
  class MultiselectTemplate < Template
    # MultiselectTemplate ������킷 String �I�u�W�F�N�g��Ԃ��܂�
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: multiselect\n"
      template_string += "Choices: #{choices}\n"
      template_string += "Default: #{default}\n" if default
      template_string += description_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
