#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/template'
require 'deft/abstract-template'
require 'time-stamp'

update(%q$LastChangedDate$)

module Deft 
  # multiselect タイプの Template をあらわすクラス
  class MultiselectTemplate < AbstractTemplate
    # MultiselectTemplate をあらわす String オブジェクトを返す
    public
    def to_s
      return template_string( 'multiselect', 'default', 'choices' )
    end
    
    # テンプレートの型を返す
    public
    def template_type
      return 'multiselect'
    end    
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::MultiselectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
