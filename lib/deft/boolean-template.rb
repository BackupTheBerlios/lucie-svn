#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'time-stamp'

update(%q$LastChangedDate$)

module Deft  
  # boolean タイプの Template をあらわすクラス
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate をあらわす String オブジェクトを返す
    public
    def to_s
      return template_string( 'boolean', 'default' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
