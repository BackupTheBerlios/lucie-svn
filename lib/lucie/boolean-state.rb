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
  
  class BooleanState < State
    #--
    # TODO : State クラスに引き上げる    
    #++  
    public
    def initialize( aQuestion )
      @question = aQuestion
    end

    #--
    # TODO : State クラスに引き上げる    
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
      class #{aQuestion.name.to_state_class_name} < Lucie::BooleanState
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
