#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'time-stamp'

update(%q$Date$)

module Deft
  class ConcreteState
    STATES = {}
    Question::QUESTIONS.values.each do |each|
      STATES[each.name] = each.concrete_state
    end 
    
    # �o�^����Ă��� Concrete State �I�u�W�F�N�g�𖼑O�Ō�������
    public
    def self.[]( stateNameString )
      return STATES[stateNameString]
    end
    
    # Concrete State �𖼑O�œo�^����
    public
    def self.[]=( stateNameString, concreteState )
      STATES[stateNameString] = concreteState
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: