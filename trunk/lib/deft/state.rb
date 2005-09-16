#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'debconf/client'
require 'deft/concrete-state'
require 'deft/string'
require 'deft/time-stamp'
require 'singleton'

include Debconf::Client

module Deft
  update(%q$Id$)

  # Question ���֥������Ȥ��� State �ѥ�����γ� concrete state ���饹��
  # �������륯�饹���ޤ������٤Ƥ� concrete state ���饹�οƤȤʤ륯�饹��
  class State    
    include Singleton
    
    attr_reader :name
    attr_reader :first_state
    attr_reader :priority
    
    # �ǥХå���
    public
    def inspect
      return "#<State: @name=\"#{@name}\", @first_state=\"#{@first_state}\">"
    end
    
    # ̾�����ǽ�� State �Ǥ��뤫�ɤ����򥻥åȤ���
    # ConcreteState �Ȥ�����Ͽ���롣
    public
    def enhance( aQuestion )
      @question = aQuestion
      @name = @question.name
      @priority = @question.priority
      @first_state = @question.first_question
      ConcreteState[@name] = self
    end

    private
    def communicate_debconf( questionNameString, priorityString ) 
      input( priorityString, questionNameString )
      rc = go
      return rc
    end
    
    private
    def transit_backup( aDebconfContext )
      communicate_debconf( aDebconfContext.current_state.name, aDebconfContext.current_state.priority )
      aDebconfContext.backup
    end

    private
    def transit_finish( aDebconfContext )
      rc = communicate_debconf( aDebconfContext.current_state.name, aDebconfContext.current_state.priority )
      if rc == 30
        aDebconfContext.backup 
        return aDebconfContext.current_state
      end
      aDebconfContext.current_state = nil
      return nil
    end
    
    private
    def transit_string_state( aDebconfContext )
      rc = communicate_debconf( aDebconfContext.current_state.name, aDebconfContext.current_state.priority )
      if rc == 30
        aDebconfContext.backup 
        return aDebconfContext.current_state
      end
      aDebconfContext.current_state = Deft::ConcreteState[@question.next_question]
    end

    private
    def transit_hash_state( aDebconfContext )
      rc = communicate_debconf( aDebconfContext.current_state.name, aDebconfContext.current_state.priority )
      if rc == 30
        aDebconfContext.backup 
        return aDebconfContext.current_state
      end
      aDebconfContext.current_state = Deft::ConcreteState[@question.next_question[get(@name)]]
    end
    
    private
    def transit_proc_state( aDebconfContext )
      rc = communicate_debconf( aDebconfContext.current_state.name, aDebconfContext.current_state.priority )
      if rc == 30
        aDebconfContext.backup 
        return aDebconfContext.current_state
      end
      aDebconfContext.current_state = Deft::ConcreteState[@question.next_question.call(get(@name))]
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
