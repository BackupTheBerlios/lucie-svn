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
      raise NotImplementedError, 'abstract method'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
