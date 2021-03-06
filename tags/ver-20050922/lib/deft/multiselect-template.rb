#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'deft/time-stamp'

module Deft 
  update(%q$Id$)

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
    def inspect # :nodoc:
      return "#<Deft::MultiselectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
