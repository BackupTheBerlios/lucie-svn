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
    
    public
    def transit( aDebconfContext )
      input @priority, @question
      go
    end

    #--
    # FIXME : 生成されるクラスを singleton にする
    #++
    def self.marshal( aQuestion )
      next_state_with_true = aQuestion.next_question[true].to_state_class_name || 'nil'
      next_state_with_false = aQuestion.next_question[false].to_state_class_name || 'nil'      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Lucie::BooleanState
        public
        def transit( aDebconfContext )
          aDebconfContext.current_state = \\
          case get( @question.name )
          when 'true'
            #{next_state_with_true}
          when 'false'
            #{next_state_with_false}
          else
            raise "This shouldn't happen"
          end
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
