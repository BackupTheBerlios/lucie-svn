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
  
  # select �^�C�v�� Template ������킷�N���X
  class SelectTemplate < Template
    # SelectTemplate ������킷 String �I�u�W�F�N�g��Ԃ��܂�
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: select\n"
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