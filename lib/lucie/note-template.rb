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
  
  # note タイプの Template をあらわすクラス
  class NoteTemplate < Template
    # NoteTemplate をあらわす String オブジェクトを返します
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: note\n"
      template_string += description_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
