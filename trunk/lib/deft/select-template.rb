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
  # select �^�C�v�� Template ������킷�N���X
  class SelectTemplate < AbstractTemplate
    # SelectTemplate ������킷 String �I�u�W�F�N�g��Ԃ�
    public
    def to_s
      return template_string( 'select', 'default', 'choices' )
    end
    
    # �e���v���[�g�̌^��Ԃ�
    public
    def template_type
      return 'select'
    end
    
    # �f�o�b�O�p
    public
    def inspect
      return "#<Deft::SelectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: