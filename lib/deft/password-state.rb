#
# $Id: string-state.rb 184 2005-02-16 08:58:36Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 184 $
# License::  GPL2

require 'lucie/state'
require 'lucie/string'
require 'lucie/time-stamp'

module Deft
  
  Lucie.update(%q$Date: 2005-02-16 17:58:36 +0900 (Wed, 16 Feb 2005) $)
  
  # password �^�e���v���[�g�ϐ��̎��₪�\������Ă����Ԃ�\���N���X
  class PasswordState < State
    # Question �I�u�W�F�N�g����Ή����� PasswordState �N���X�̎q�N���X������킷�������Ԃ�
    def self.marshal( aQuestion )
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Deft::PasswordState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_state = DebconfContext::STATES['#{aQuestion.next_question}']
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