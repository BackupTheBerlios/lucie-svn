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

include Debconf::ConfModule

# �g����: ���炩���� Template �� Question �̒�`�� require ���A���s
# 
# ��:
# ruby -r '�e���v���[�g��`.rb' '���⍀�ڒ�`.rb' debconfcontext.rb 
#
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

########
# MAIN #
########

if __FILE__ == $PROGRAM_NAME
  title "#{$package_name} �̃J�X�^�}�C�Y"
  debconf_context = DebconfContext.new  
  loop do 
    rc = debconf_context.transit
    exit 0 if rc.nil?
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: