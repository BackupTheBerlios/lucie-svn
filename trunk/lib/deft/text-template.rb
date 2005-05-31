#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'time-stamp'

module Deft  
  # text 型の Template をあらわすクラス
  class TextTemplate < AbstractTemplate  
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    public 
    def default=( defaultString ) # :nodoc:
      raise Exception::InvalidAttributeException
    end
    
    # TextTemplate の RFC822 による表現を返す
    public
    def to_s
      return template_string( 'text' )
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::TextTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
