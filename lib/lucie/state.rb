#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'

module Lucie
  
  update(%q$Date$)
  
  # 状態遷移表から State パターンの各 ConcreteState クラスを生成する。
  #--
  # TODO: 各 ConcreteState は特異オブジェクトにする。
  #++  
  class State    
    PRIORITY_LOW = 'low'.freeze
    PRIORITY_MEDIUM = 'medium'.freeze
    PRIORITY_HIGH = 'high'.freeze
    PRIORITY_CRITICAL = 'critical'.freeze
    
    # あたらしい State をかえす。
    public
    def initialize( questionString, priorityString )
      raise TypeError, "First argument must be a String." unless questionString.kind_of?( String )
      raise Exception::UnsupportedPriorityException, "Unsupported priority : #{priorityString}" unless valid_priority?( priorityString ) 
      
      @question = questionString
      @priority = priorityString
    end
    
    # 次の State に遷移する
    public
    def transit( aDebconfContext )
      raise NotImplementedError, 'abstract method'
    end
    
    # Ruby のスクリプトを返す
    public
    def self.marshal( aQuestion )
      raise NotImplementedError, 'abstract method'
    end
    
    private
    def supported_priorities
      [ PRIORITY_LOW, PRIORITY_MEDIUM, PRIORITY_HIGH, PRIORITY_CRITICAL ]
    end
    
    private
    def valid_priority?( priorityString )
      supported_priorities.include? priorityString
    end
    
    #--
    # TODO: need to implement Exception & Error using exception
    #++
    module Exception #:nodoc:
      class UnsupportedPriorityException < ::Exception #:nodoc:
      end
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
