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
    
    #--
    # FIXME : ポリモルフィズム
    #++
    public
    def self.define_state( aQuestion )
      case aQuestion.template
      when StringTemplate
        require 'lucie/string-state'
        eval StringState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new" )        
      when MultiselectTemplate
        require 'lucie/multiselect-state'
        eval MultiselectState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new( aQuestion )" )      
      when SelectTemplate
        require 'lucie/select-state'
        eval SelectState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new( aQuestion )" )     
      when NoteTemplate
        require 'lucie/note-state'
        eval NoteState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new" )
      when BooleanTemplate
        require 'lucie/boolean-state'
        eval BooleanState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new( aQuestion )" )      
      when TextTemplate
        require 'lucie/text-state'
        eval TextState.marshal( aQuestion )
        return eval( "#{aQuestion.name.to_state_class_name}.new" )
      else
        raise "This shouldn't happen!"
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
