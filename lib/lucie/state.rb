#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'

module Lucie
  
  update(%q$Date$)
  
  # ��ԑJ�ڕ\���� State �p�^�[���̊e ConcreteState �N���X�𐶐�����B
  #--
  # TODO: �e ConcreteState �͓��كI�u�W�F�N�g�ɂ���B
  #++  
  class State    
    # ���� State �ɑJ�ڂ���
    public
    def transit( aDebconfContext )
      raise NotImplementedError, 'abstract method'
    end
    
    # Ruby �̃X�N���v�g��Ԃ�
    public
    def self.marshal( aQuestion )
      raise NotImplementedError, 'abstract method'
    end
    
    #--
    # FIXME : �|�������t�B�Y��
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
