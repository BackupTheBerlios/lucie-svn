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
  
  # Question オブジェクトから State パターンの各 concrete state クラスを生成するクラス。
  # また、すべての concrete state クラスの親となるクラス。
  class State    
    include Singleton
    
    # 次の State に遷移する
    public
    def transit( aDebconfContext )  
      stdout = aDebconfContext.stdout
      stdin = aDebconfContext.stdin    
      input stdout, stdin, aDebconfContext.current_question.priority, aDebconfContext.current_question.name
      go stdout, stdin
    end
    
    # +aQuestion+ を表す concrete class の Ruby スクリプトを文字列で返す
    public
    def self.marshal_concrete_state( aQuestion )
      raise NotImplementedError, 'abstract method'
    end
    
    # +aQuestion+ を表す concrete state のインスタンスを返す
    #--
    # FIXME : 相互参照しちゃってるので Question クラスへ移動する
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
    
    # 質問名 => concrete state クラス名へ変換
    # 
    # 例 : 'lucie/hello-world' => 'Lucie__HelloWorld'
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
