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
  # text �^�C�v�� Template ������킷�N���X
  class TextTemplate < AbstractTemplate  
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    public 
    def default=( defaultString ) # :nodoc:
      raise Exception::InvalidAttributeException
    end
    
    # �e���v���[�g�̌^��Ԃ�
    public
    def template_type
      return 'text'
    end
    
    # TextTemplate ������킷 String �I�u�W�F�N�g��Ԃ�
    public
    def to_s
      return template_string( 'text' )
    end
    
    # �f�o�b�O�p
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
