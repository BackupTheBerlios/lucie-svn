#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'time-stamp'

update(%q$Date$)

module Deft
  # Concrete State ���Ǘ�����N���X�B
  class ConcreteState
    STATES = {}
    
    @@first_state = nil
    
    # �o�^����Ă��� Concrete State �̃��X�g���N���A����
    def self.clear
      STATES.clear
    end
    
    # �o�^����Ă��� Concrete State �̃��X�g��Ԃ�
    def self.states
      return STATES.values
    end
    
    # �o�^����Ă��� Concrete State �I�u�W�F�N�g�𖼑O�Ō�������
    def self.[]( stateNameString )
      return STATES[stateNameString]
    end
    
    # Concrete State �𖼑O�œo�^����
    def self.[]=( stateNameString, concreteState )
      STATES[stateNameString] = concreteState
      @@first_state = concreteState if concreteState.first_state
    end
    
    # �ŏ��� Concrete State ��Ԃ�
    def self.first_state
      return @@first_state
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: