#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'lucie/time-stamp'

update(%q$LastChangedDate$)

module Deft  
  # note �^�C�v�� Template ������킷�N���X
  class NoteTemplate < AbstractTemplate
    # NoteTemplate ������킷 String �I�u�W�F�N�g��Ԃ�
    public
    def to_s
      return template_string( 'note' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
