#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/state'
require 'lucie/string'
require 'time-stamp'

update(%q$Date$)

module Deft  
  # boolean �^�e���v���[�g�ϐ��̎��₪�\������Ă����Ԃ�\���N���X
  class BooleanState < State
    # Question �I�u�W�F�N�g����Ή����� BooleanState �N���X�̎q�N���X������킷�������Ԃ�
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
      class #{aQuestion.state_class_name} < Deft::BooleanState
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
