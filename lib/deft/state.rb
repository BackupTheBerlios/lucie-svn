#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

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
    
    # 次の State に遷移する
    public
    def transit( aDebconfContext )   
      input aDebconfContext.current_question.priority, aDebconfContext.current_question.name
      go
    end
    
    # +aQuestion+ を表す concrete class の Ruby スクリプトを文字列で返す
    public
    def self.marshal_concrete_state( aQuestion )
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
