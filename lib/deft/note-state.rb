#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'deft/state'
require 'time-stamp'

update(%q$Date$)

module Deft
  # note 型テンプレート変数の質問が表示されている状態を表すクラス
  class NoteState < State
    # Question オブジェクトから対応する NoteState クラスの子クラスをあらわす文字列を返す
    def self.marshal_concrete_state( aQuestion ) 
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.state_class_name} < Deft::NoteState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          next_question = aDebconfContext.next_question[get( '#{aQuestion.name}' )]
          aDebconfContext.current_question = Deft::Question[next_question]
          aDebconfContext.current_state    = Deft::ConcreteState[next_question]
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
