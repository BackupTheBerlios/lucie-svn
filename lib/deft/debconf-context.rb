#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'deft'
require 'deft/concrete-state'

update(%q$Date$)

module Deft
  # Debconf による画面遷移を表すクラス
  class DebconfContext   
    # 現在の Question オブジェクト
    attr_accessor :current_question
    # 現在の Concrete State
    attr_accessor :current_state
    # Debconf との通信に用いる標準入力 (デバッグ用。Test Case 中 で Mock などを代入する)
    attr_accessor :stdin
    # Debconf との通信に用いる標準出力 (デバッグ用。Test Case 中 で Mock などを代入する)
    attr_accessor :stdout
    
    # あたらしい DebconfContext オブジェクトを返す
    public
    def initialize
      register_concrete_state
      @current_question = get_start_question
      @current_state = ConcreteState[@current_question.name]
      @stdout = STDOUT
      @stdin = STDIN
    end
    
    # 次の質問へ遷移する
    public
    def transit
      @current_state.transit self
    end
    
    # 入力に対する次の質問を返す
    public
    def next_question( inputString )
      _next_question = current_question.next_question
      case _next_question
      when String
        return _next_question
      when Hash
        return _next_question[ inputString ]
      when Proc
        return _next_question.call( inputString )
      else
        raise "This shouldn't happen"
      end
    end
    
    private
    def register_concrete_state
      Question::QUESTIONS.values.each do |each|
        ConcreteState[each.name] = each.concrete_state
      end
    end
    
    private
    def get_start_question
      Question::QUESTIONS.values.each do |each|        
        return each if each.first_question
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: