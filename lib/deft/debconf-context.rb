#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'lucie'

module Deft
  
  # FIXME : update ���\�b�h�� Deft ���W���[���ֈړ�
  Lucie.update(%q$Date$)
  
  # Debconf �ɂ���ʑJ�ڂ�\���N���X
  class DebconfContext
    # Debconf �̊e��ʂ�\�� Concrete State �̃n�b�V��
    STATES = {}
    
    # ���݂� Question �I�u�W�F�N�g
    attr_accessor :current_question
    # ���݂� Concrete State
    attr_accessor :current_state
    # Debconf �Ƃ̒ʐM�ɗp����W������ (�f�o�b�O�p�BTest Case �� �� Mock �Ȃǂ�������)
    attr_accessor :stdin
    # Debconf �Ƃ̒ʐM�ɗp����W���o�� (�f�o�b�O�p�BTest Case �� �� Mock �Ȃǂ�������)
    attr_accessor :stdout
    
    # �����炵�� DebconfContext �I�u�W�F�N�g��Ԃ�
    public
    def initialize
      register_concrete_state
      @current_question = get_start_question
      @current_state = STATES[@current_question.name]
      @stdout = STDOUT
      @stdin = STDIN
    end
    
    # ���̎���֑J�ڂ���
    public
    def transit
      @current_state.transit self
    end
    
    private
    def register_concrete_state
      Lucie::Question::QUESTIONS.values.each do |each|
        STATES[each.name] = each.concrete_state
      end
    end
    
    private
    def get_start_question
      Lucie::Question::QUESTIONS.values.each do |each|        
        return each if each.first_question
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: