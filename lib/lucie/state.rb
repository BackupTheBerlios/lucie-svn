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
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
