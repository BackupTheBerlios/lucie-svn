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
    # 現在の Concrete State
    attr_accessor :current_state
    # 直前の Concrete State
    attr_reader :last_state
    
    # あたらしい DebconfContext オブジェクトを返す
    public
    def initialize
      @state_stack = []
      @current_state = ConcreteState.first_state
      @state_stack.push( @current_state )
    end
    
    # 次の質問へ遷移する
    public
    def transit
      @current_state.transit self
    end

    public
    def last_state
      return @state_stack.last
    end
    
    # 現在の状態を変更する
    public
    def current_state=( aState )
      @state_stack.push( @current_state )
      @current_state = aState
    end
    
    # 直前の状態に戻る
    public
    def backup
      @current_state = @state_stack.pop
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: