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
  # boolean ?^?C?v? Template ??巽鱈??N???X
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate ??巽鱈? String ?I?u?W?F?N?g??夬申
    public
    def to_s
      return template_string( 'boolean', 'default' )
    end
    
    # テンプレートの型を文字列で返す
    public
    def template_type
      return 'boolean'
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
