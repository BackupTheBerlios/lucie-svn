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
  
  # note �^�C�v�� Template ������킷�N���X
  class NoteTemplate < Template
    # NoteTemplate ������킷 String �I�u�W�F�N�g��Ԃ��܂�
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
