#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'time-stamp'

module Deft
  # Concrete State ��������륯�饹��
  class ConcreteState
    STATES = {}
    
    @@first_state = nil
    
    # ��Ͽ����Ƥ��� Concrete State �Υꥹ�Ȥ򥯥ꥢ����
    def self.clear
      STATES.clear
    end
    
    # ��Ͽ����Ƥ��� Concrete State �Υꥹ�Ȥ��֤�
    def self.states
      return STATES.values
    end
    
    # ��Ͽ����Ƥ��� Concrete State ���֥������Ȥ�̾���Ǹ�������
    def self.[]( stateNameString )
      return STATES[stateNameString]
    end
    
    # Concrete State ��̾������Ͽ����
    def self.[]=( stateNameString, concreteState )
      STATES[stateNameString] = concreteState
      @@first_state = concreteState if concreteState.first_state
    end
    
    # �ǽ�� Concrete State ���֤�
    def self.first_state
      return @@first_state
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
