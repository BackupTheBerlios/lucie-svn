#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/state'
require 'lucie/string'
require 'lucie/time-stamp'

module Deft
  
  Lucie.update(%q$Date$)
  
  # boolean �^�e���v���[�g�ϐ��̎��₪�\������Ă����Ԃ�\���N���X
  class BooleanState < State
    # Question �I�u�W�F�N�g����Ή����� BooleanState �N���X�̎q�N���X������킷�������Ԃ�
    def self.marshal( aQuestion )  
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Deft::BooleanState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_state = DebconfContext::STATES[@question.next_question[get( '#{aQuestion.name}' )]]
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
