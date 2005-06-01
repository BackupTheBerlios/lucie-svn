#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'time-stamp'

module Deft
  # string 型の Template をあらわすクラス
  class StringTemplate < AbstractTemplate   
    # StringTemplate の RFC822 による表現を返す
    public
    def to_s
      super
      return template_string( 'string', 'default' )
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
