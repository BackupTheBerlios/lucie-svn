#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'debconf/client'
require 'deft/state'
require 'English'
require 'lucie'

include Debconf::ConfModule

module Deft
  
  # FIXME : update メソッドを Deft モジュールへ移動
  Lucie.update(%q$Date$)
  
  class DebconfContext
    STATES = {}
    attr_accessor :current_state
    
    public
    def initialize
      Lucie::Question::QUESTIONS.values.each do |each|
        STATES[each.name] = State.concrete_state( each )
      end
      @current_state = get_start_state
    end
    
    public
    def transit
      @current_state.transit self
    end
    
    private
    def get_start_state
      Lucie::Question::QUESTIONS.values.each do |each|
        return STATES[each.name] if each.first_question
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: