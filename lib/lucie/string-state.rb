#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'lucie/state'
require 'lucie/time-stamp'

module Lucie
  
  update(%q$Date$)
  
  class StringState < State
    public
    def transit( aDebconfContext )
      input @priority, @question
      go
    end
    
    #--
    # FIXME : ���������N���X�� singleton �ɂ���
    #++
    def self.marshal( aQuestion )
      next_question_state = aQuestion.next_question.to_state_class_name || 'nil'
      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Lucie::StringState
        public
        def transit( aDebconfContext )
          aDebconfContext.current_state = #{next_question_state}
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
