#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/concrete-state'
require 'debconf/client'
require 'time-stamp'
require 'singleton'

include Debconf::ConfModule

update(%q$Date$)

module Deft
  # Question オブジェクトから State パターンの各 concrete state クラスを生成するクラス。
  # また、すべての concrete state クラスの親となるクラス。
  class State    
    include Singleton
    
    attr_reader :name
    attr_reader :priority
    attr_reader :first_state
    
    # 名前、プライオリティ、最初の State であるかどうかをセットし、
    # ConcreteState として登録する。
    public
    def enhance( nameString, priorityString, firstState, rubyString )
      @name = nameString
      @priority = priorityString
      @first_state = firstState
      @ruby_string = rubyString
      ConcreteState[@name] = self
    end
    
    public
    def to_ruby
      return @ruby_string
    end
       
    # 次の State に遷移する
    public
    def transit( aDebconfContext )   
      input aDebconfContext.current_state.priority, aDebconfContext.current_state.name
      go
    end
    
    # +aQuestion+ を表す concrete class の Ruby スクリプトを文字列で返す
    public
    def self.marshal_concrete_state( aQuestion )
      if aQuestion.next_question.nil?
        return ( <<-CLASS_DEFINITION ).unindent_auto
        class #{aQuestion.state_class_name} < Deft::State
          public
          def transit( aDebconfContext )
            super aDebconfContext
            aDebconfContext.current_state = nil
          end
        end
        CLASS_DEFINITION
      end
      
      next_question = eval( aQuestion.next_question ) 
      case next_question
      when String
        current_state = "Deft::ConcreteState[next_question]"
      when Hash
        current_state = "Deft::ConcreteState[next_question[get('#{aQuestion.name}')]]"
      when Proc
        current_state = "Deft::ConcreteState[next_question.call(get('#{aQuestion.name}'))]"
      else
        raise "Unsupported next_question type: #{next_question.class}"
      end
      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::State
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_state = #{current_state}
        end
        
        private
        def next_question
   #{('return ' + aQuestion.next_question.lstrip.rstrip).indent(6)}
        end
      end
      CLASS_DEFINITION
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
