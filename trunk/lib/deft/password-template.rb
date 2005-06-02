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
  # password 型の Template をあらわすクラス
  class PasswordTemplate < AbstractTemplate   
    # PasswordTemplate の RFC822 による表現を返す
    public
    def to_s
      super
      return template_string( 'password', 'default' )
    end
    
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::PasswordTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
