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
  
  class TextState < State
    public
    def transit( aDebconfContext )
      input @priority, @question
      go
    end
    
    #--
    # FIXME : ¶¬‚³‚ê‚éƒNƒ‰ƒX‚ð singleton ‚É‚·‚é
    #++
    def self.marshal( aQuestion ) 
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Lucie::TextState
        public
        def transit( aDebconfContext )
          aDebconfContext.current_state = aDebconfContext::STATES['#{aQuestion.next_question}']
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