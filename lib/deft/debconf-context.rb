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
    
    # �����炵�� DebconfContext �I�u�W�F�N�g��Ԃ�
    public
    def initialize
      @current_state = ConcreteState.first_state
    end
    
    # ���̎���֑J�ڂ���
    public
    def transit
      @current_state.transit self
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: