#!/usr/bin/ruby -I/home/takamiya/eclipse/workspace/Lucie/lib
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie'
require 'lucie/state'
require 'debconf/client'
require 'English'
require 'lucie_vm_template'
require 'lucie_vm_question'

include Debconf::ConfModule

class DebconfContext
  STATES = {}
  attr_accessor :current_state
  
  public
  def initialize
    Lucie::Question::QUESTIONS.values.each do |each|
      STATES[each.name] = State.define_state( each )
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

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: