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
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
