#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'time-stamp'

update(%q$Id$)

module Deft  
  # select 型のテンプレートを表すクラス
  class SelectTemplate < AbstractTemplate
    # SelectTemplate の RFC822 による表現を返す
    public
    def to_s
      raise Exception::RequiredAttributeException if @choices.nil?
      super
      return template_string( 'select', 'default', 'choices' )
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
