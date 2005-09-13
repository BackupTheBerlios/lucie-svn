#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'time-stamp'

update(%q$Id$)

module Deft  
  # boolean 型のテンプレートを表すクラス
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate の RFC822 による表現を返す
    public
    def to_s
      super
      return template_string( 'boolean', 'default' )
    end
    
    # boolean template では choices 属性は利用できない
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end

    # 'true' か 'false' 以外の default をはねる
    public
    def default=( defaultString ) # :nodoc:
      unless (defaultString == 'true') or (defaultString == 'false')
        raise Deft::Exception::InvalidAttributeException, "default must be 'true' or 'false'"
      end
      super
    end
    
    # デバッグ用
    public
    def inspect # :nodoc:
      return "#<Deft::BooleanTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
