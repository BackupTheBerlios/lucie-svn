#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/question'
require 'time-stamp'

update(%q$Date$)

module Deft
  # concrete state を管理するクラス。
  class ConcreteState
    STATES = {}
    
    # 登録されている Concrete State のリストを返す
    public
    def self.states
      return STATES.values
    end
    
    # 登録されている Concrete State オブジェクトを名前で検索する
    public
    def self.[]( stateNameString )
      return STATES[stateNameString]
    end
    
    # Concrete State を名前で登録する
    public
    def self.[]=( stateNameString, concreteState )
      STATES[stateNameString] = concreteState
      @@first_state = concreteState if concreteState.first_state
    end
    
    # 最初の Concrete State を返す
    public
    def self.first_state
      return @@first_state
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: