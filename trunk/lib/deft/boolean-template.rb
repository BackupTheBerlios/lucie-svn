#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'time-stamp'

module Deft  
  # boolean 型のテンプレートを表すクラス
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate の RFC822 による表現を返す
    public
    def to_s
      unless ( (@short_description and @extended_description) or
               (@short_description_ja and @extended_description_ja) )
        raise Exception::RequiredAttributeException
      end
      return template_string( 'boolean', 'default' )
    end
    
    # boolean template では choices 属性は利用できない
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::BooleanTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
