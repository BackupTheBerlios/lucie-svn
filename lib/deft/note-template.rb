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
  # note タイプの Template をあらわすクラス
  class NoteTemplate < AbstractTemplate
    # NoteTemplate をあらわす String オブジェクトを返す
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
