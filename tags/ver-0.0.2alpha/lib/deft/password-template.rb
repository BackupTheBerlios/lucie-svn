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
  # password �^�C�v�� Template ������킷�N���X
  class PasswordTemplate < AbstractTemplate   
    # PasswordTemplate ������킷 Password �I�u�W�F�N�g��Ԃ�
    public
    def to_s
      return template_string( 'password' )
    end
    
    # �e���v���[�g�̌^��Ԃ�
    public
    def template_type
      return 'password'
    end
    
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # �f�o�b�O�p
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
