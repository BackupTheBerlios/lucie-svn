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
  # multiselect �^�e���v���[�g�ϐ��̎��₪�\������Ă����Ԃ�\���N���X
  class MultiselectState < State
    # Question �I�u�W�F�N�g����Ή����� MultiselectState �N���X�̎q�N���X������킷�������Ԃ�
    def self.marshal_concrete_state( aQuestion )  
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::MultiselectState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_question = Deft::Question['#{aQuestion.next_question}']
          aDebconfContext.current_state    = Deft::ConcreteState['#{aQuestion.next_question}']
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