#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'deft'
require 'deft/concrete-state'

module Deft
  update(%q$Id$)

  # Debconf �ˤ��������ܤ�ɽ�����饹
  class DebconfContext   
    # ���ߤ� Concrete State
    attr_reader :current_state
    
    # �����餷�� DebconfContext ���֥������Ȥ��֤�
    public
    def initialize
      @state_stack = []
      @current_state = ConcreteState.first_state
      @state_stack.push( @current_state )
    end
    
    # ���μ�������ܤ���
    public
    def transit
      @current_state.transit self
    end

    # ľ���� Concrete State ���֤�
    public
    def last_state
      return @state_stack.last
    end
    
    # ���ߤξ��֤��ѹ�����
    public
    def current_state=( aState )
      @state_stack.push( @current_state )
      @current_state = aState
    end
    
    # ľ���ξ��֤����
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
