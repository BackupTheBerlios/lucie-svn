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
  # select タイプの Template をあらわすクラス
  class SelectTemplate < AbstractTemplate
    # SelectTemplate をあらわす String オブジェクトを返す
    public
    def to_s
      return template_string( 'select', 'default', 'choices' )
    end
    
    # テンプレートの型を返す
    public
    def template_type
      return 'select'
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::SelectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: