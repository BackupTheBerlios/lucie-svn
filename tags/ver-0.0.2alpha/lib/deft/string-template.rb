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
  # string タイプの Template をあらわすクラス
  class StringTemplate < AbstractTemplate   
    # StringTemplate をあらわす String オブジェクトを返す
    public
    def to_s
      return template_string( 'string', 'default' )
    end
    
    # テンプレートの型を返す
    public
    def template_type
      return 'string'
    end
    
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::StringTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
