#
# $Id: state.rb 49 2005-02-07 04:30:20Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 49 $
# License::  GPL2

require 'lucie/string'
require 'lucie/state'
require 'lucie/time-stamp'

module Lucie
  
  update(%q$Date: 2005-02-07 13:30:20 +0900 (Mon, 07 Feb 2005) $)
  
  class NoteState < State      
    public
    def transit( aDebconfContext )
      input @priority, @question
      go
    end
    
    def self.marshal( aQuestion )
      state_class_name = aQuestion.name.to_state_class_name
      next_question_state = aQuestion.next_question.to_state_class_name || 'nil'
      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{state_class_name} < Lucie::NoteState
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
