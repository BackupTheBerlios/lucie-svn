#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'lucie'

module Deft
  
  # FIXME : update メソッドを Deft モジュールへ移動
  Lucie.update(%q$Date$)
  
  # Debconf による画面遷移を表すクラス
  class DebconfContext
    # Debconf の各画面を表す Concrete State のハッシュ
    STATES = {}
    
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
      @current_state = STATES[@current_question.name]
      @stdout = STDOUT
      @stdin = STDIN
    end
    
    # 次の質問へ遷移する
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