#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'debconf/client'
require 'time-stamp'
require 'singleton'

include Debconf::ConfModule

update(%q$Date$)

module Deft
  # Question �I�u�W�F�N�g���� State �p�^�[���̊e concrete state �N���X�𐶐�����N���X�B
  # �܂��A���ׂĂ� concrete state �N���X�̐e�ƂȂ�N���X�B
  class State    
    include Singleton
    
    # ���� State �ɑJ�ڂ���
    public
    def transit( aDebconfContext )   
      input aDebconfContext.current_question.priority, aDebconfContext.current_question.name
      go
    end
    
    # +aQuestion+ ��\�� concrete class �� Ruby �X�N���v�g�𕶎���ŕԂ�
    public
    def self.marshal_concrete_state( aQuestion )
      raise NotImplementedError, 'abstract method'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
