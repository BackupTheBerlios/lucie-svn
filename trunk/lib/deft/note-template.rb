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
  # note ���� Template �򤢤�魯���饹
  class NoteTemplate < AbstractTemplate
    # NoteTemplate �� RFC822 �ˤ��ɽ�����֤�
    public
    def to_s
      super
      return template_string( 'note' )
    end
    
    public 
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    public 
    def default=( defaultString ) # :nodoc:
      raise Exception::InvalidAttributeException
    end
    
    # �ǥХå���
    public
    def inspect # :nodoc:
      return "#<Deft::NoteTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
