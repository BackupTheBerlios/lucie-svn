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
  
  class NoteState < State
    #--
    # FIXME : State クラスへ引き上げ
    #++  
    public
    def initialize( aQuestion )
      @question = aQuestion
    end

    #--
    # FIXME : State クラスへ引き上げ
    #++      
    public
    def transit( aDebconfContext )
      input @question.priority, @question.name
      go
    end
    
    #--
    # FIXME : 生成されるクラスを singleton にする
    #++
    def self.marshal( aQuestion ) 
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Lucie::NoteState
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
