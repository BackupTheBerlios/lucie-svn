#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'debconf/client'
require 'lucie/time-stamp'
require 'singleton'

include Debconf::ConfModule

module Deft
  
  Lucie.update(%q$Date$)
  
  # Question �I�u�W�F�N�g���� State �p�^�[���̊e concrete state �N���X�𐶐�����N���X�B
  # �܂��A���ׂĂ� concrete state �N���X�̐e�ƂȂ�N���X�B
  class State    
    include Singleton
    
    # ���� State �ɑJ�ڂ���
    public
    def transit( aDebconfContext )  
      stdout = aDebconfContext.stdout
      stdin = aDebconfContext.stdin    
      input stdout, stdin, aDebconfContext.current_question.priority, aDebconfContext.current_question.name
      go stdout, stdin
    end
    
    # +aQuestion+ ��\�� concrete class �� Ruby �X�N���v�g�𕶎���ŕԂ�
    public
    def self.marshal_concrete_state( aQuestion )
      raise NotImplementedError, 'abstract method'
    end
    
    # +aQuestion+ ��\�� concrete state �̃C���X�^���X��Ԃ�
    #--
    # FIXME : ���ݎQ�Ƃ�������Ă�̂� Question �N���X�ֈړ�����
    #++
    public
    def self.concrete_state( aQuestion )
      require 'deft/boolean-state'
      require 'deft/multiselect-state'
      require 'deft/note-state'
      require 'deft/password-state'
      require 'deft/select-state'
      require 'deft/string-state'
      require 'deft/text-state'
      eval aQuestion.template.__send__( :marshal, aQuestion )
      return eval( "#{state_class_name( aQuestion.name )}.instance" ) 
    end
    
    # ���▼ => concrete state �N���X���֕ϊ�
    # 
    # �� : 'lucie/hello-world' => 'Lucie__HelloWorld'
    #
    public
    def self.state_class_name( questionNameString )
      return questionNameString.gsub('-', '_').split('/').map do |each|
        each.to_pascal_style
        end.join('__')
      end
    end
  end
  
  ### Local variables:
  ### mode: Ruby
  ### indent-tabs-mode: nil
  ### End:
