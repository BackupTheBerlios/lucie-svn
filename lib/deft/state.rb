#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'deft/concrete-state'
require 'debconf/client'
require 'time-stamp'
require 'singleton'

include Debconf::Client

update(%q$Date$)

module Deft
  # Question オブジェクトから State パターンの各 concrete state クラスを生成するクラス。
  # また、すべての concrete state クラスの親となるクラス。
  class State    
    include Singleton
    
    attr_reader :name
    attr_reader :priority
    attr_reader :first_state
    
    # デバッグ用
    public
    def inspect
      return "#<State: @name=\"#{@name}\", @priority=\"#{@priority}\", @first_state=\"#{@first_state}\">"
    end
    
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
      rc = go
      aDebconfContext.backup if rc == 30 
    end
    
    # +aQuestion+ を表す concrete class の Ruby スクリプトを文字列で返す
    public
    def self.marshal_concrete_state( aQuestion )
      if aQuestion.next_question.nil?
        return ( <<-CLASS_DEFINITION ).unindent_auto
        class #{aQuestion.state_class_name} < Deft::State
          public
          def transit( aDebconfContext )
            current_state = aDebconfContext.current_state
            super( aDebconfContext )
            unless ( current_state == aDebconfContext.current_state ) 
              return aDebconfContext.current_state
            end
            aDebconfContext.current_state = nil
            return nil
          end
        end
        CLASS_DEFINITION
      end
      
      case aQuestion.next_question
      when /\A[\w\-]+\Z/, /\A[\w\-]+\/[\w\-]+\Z/
        return ( <<-CLASS_DEFINITION ).unindent_auto
        class #{aQuestion.state_class_name} < Deft::State
          public
          def transit( aDebconfContext )
            current_state = aDebconfContext.current_state
            super( aDebconfContext )
            unless ( current_state == aDebconfContext.current_state ) 
              return aDebconfContext.current_state
            end
            aDebconfContext.current_state = Deft::ConcreteState['#{aQuestion.next_question}']
          end
        end
        CLASS_DEFINITION
      when Hash
        next_question = aQuestion.next_question.inspect
        current_state = "Deft::ConcreteState[next_question[get('#{aQuestion.name}')]]"
      when /Proc\.new/
        next_question = aQuestion.next_question
        current_state = "Deft::ConcreteState[next_question.call(get('#{aQuestion.name}'))]"
      else
        raise "Unsupported next_question: #{aQuestion.next_question}"
      end
      
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::State
        public
        def transit( aDebconfContext )
          current_state = aDebconfContext.current_state
          super( aDebconfContext )
          unless ( current_state == aDebconfContext.current_state ) 
            return aDebconfContext.current_state
          end
          aDebconfContext.current_state = #{current_state}
        end
        
        private
        def next_question
   #{('return ' + next_question.lstrip.rstrip ).indent(6)}
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
