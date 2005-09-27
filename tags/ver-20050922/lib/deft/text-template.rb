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

  # text ���� Template �򤢤�魯���饹
  class TextTemplate < AbstractTemplate  
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    public 
    def default=( defaultString ) # :nodoc:
      raise Exception::InvalidAttributeException
    end
    
    # TextTemplate �� RFC822 �ˤ��ɽ�����֤�
    public
    def to_s
      super
      return template_string( 'text' )
    end
    
    # �ǥХå���
    public
    def inspect # :nodoc:
      return "#<Deft::TextTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: