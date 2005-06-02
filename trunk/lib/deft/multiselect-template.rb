#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/template'
require 'deft/abstract-template'
require 'time-stamp'

update(%q$Id$)

module Deft 
  # multiselect 型の Template をあらわすクラス
  class MultiselectTemplate < AbstractTemplate
    # MultiselectTemplate の RFC822 による表現を返す
    public
    def to_s
      raise Exception::RequiredAttributeException if @choices.nil?
      super
      return template_string( 'multiselect', 'default', 'choices' )
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
