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
      next_question = eval( aQuestion.next_question )
      case next_question
      when String
        current_state = "Deft::ConcreteState[next_question]"
      when Hash
        current_state = "Deft::ConcreteState[next_question[get('#{aQuestion.name}')]]"
      when Proc
        current_state = "Deft::ConcreteState[next_question.call(get('#{aQuestion.name}'))]"
      else
        raise "Unsupported next_question type: #{next_question.class}"
      end
      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::State
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_state = #{current_state}
        end
        
        private
        def next_question
   #{('return ' + aQuestion.next_question.lstrip.rstrip).indent(6)}
        end
      end
      CLASS_DEFINITION
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
