#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/state'
require 'lucie/string'
require 'time-stamp'

update(%q$Date$)

module Deft
  # multiselect 型テンプレート変数の質問が表示されている状態を表すクラス
  class MultiselectState < State
    # Question オブジェクトから対応する MultiselectState クラスの子クラスをあらわす文字列を返す
    def self.marshal_concrete_state( aQuestion )  
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::MultiselectState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_question = Deft::Question['#{aQuestion.next_question}']
          aDebconfContext.current_state    = Deft::ConcreteState['#{aQuestion.next_question}']
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