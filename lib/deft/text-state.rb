#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'lucie/state'
require 'lucie/time-stamp'

module Deft
  
  Lucie.update(%q$Date$)
  
  # text 型テンプレート変数の質問が表示されている状態を表すクラス
  class TextState < State
    # Question オブジェクトから対応する TextState クラスの子クラスをあらわす文字列を返す
    def self.marshal( aQuestion ) 
      return ( <<-CLASS_DEFINITION ).unindent_auto
      class #{aQuestion.name.to_state_class_name} < Deft::TextState
        public
        def transit( aDebconfContext )
          super aDebconfContext
          aDebconfContext.current_state = DebconfContext::STATES['#{aQuestion.next_question}']
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