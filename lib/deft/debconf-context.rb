#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'deft'
require 'deft/concrete-state'

update(%q$Date$)

module Deft
  # Debconf �ɂ���ʑJ�ڂ�\���N���X
  class DebconfContext   
    # ���݂� Concrete State
    attr_accessor :current_state
    # ���O�� Concrete State
    attr_reader :last_state
    
    # �����炵�� DebconfContext �I�u�W�F�N�g��Ԃ�
    public
    def initialize
      @state_stack = []
      @current_state = ConcreteState.first_state
      @state_stack.push( @current_state )
    end
    
    # ���̎���֑J�ڂ���
    public
    def transit
      @current_state.transit self
    end

    public
    def last_state
      return @state_stack.last
    end
    
    # ���݂̏�Ԃ�ύX����
    public
    def current_state=( aState )
      @state_stack.push( @current_state )
      @current_state = aState
    end
    
    # ���O�̏�Ԃɖ߂�
    public
    def backup
      @current_state = @state_stack.pop
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: