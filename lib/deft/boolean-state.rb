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
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::BooleanState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          next_question = aDebconfContext.current_question.next_question[get( '#{aQuestion.name}' )]
          aDebconfContext.current_question = Deft::Question[next_question]
          aDebconfContext.current_state    = Deft::ConcreteState[next_question]
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
