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
  
  class BooleanTemplate < Template
    # BooleanTemplate ������킷 String �I�u�W�F�N�g��Ԃ��܂�
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: boolean\n"
      if description
        template_string += "Description: #{short_description}\n"
        template_string += long_description + "\n"
      end
        
      if description_ja
        template_string += "Description-ja: #{short_description_ja}\n" 
        template_string += long_description_ja
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
