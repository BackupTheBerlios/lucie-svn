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
    
    # あたらしい DebconfContext オブジェクトを返す
    public
    def initialize
      @current_state = ConcreteState.first_state
    end
    
    # 次の質問へ遷移する
    public
    def transit
      @current_state.transit self
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: