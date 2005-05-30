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
  # boolean ?^?C?v? Template ??Ã§Ã­??N???X
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate ??Ã§Ã­? String ?I?u?W?F?N?g??Ôï¿½
    public
    def to_s
      return template_string( 'boolean', 'default' )
    end
    
    # ?e???v???[?g??^??Ôï¿½
    public
    def template_type
      return 'boolean'
    end
    
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # ¥Ç¥Ð¥Ã¥°ÍÑ
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
