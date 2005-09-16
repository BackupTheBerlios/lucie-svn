#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/state'
require 'deft/template'
require 'deft/time-stamp'

# 新しい質問項目を登録する
def question( nameString, &block )
  return Deft::Question.define_question( nameString, &block )
end

module Deft
  update(%q$Id$)

   module Exception
     class InvalidQuestionNameException < ::Exception; end
     class InvalidNextQuestionTypeException < ::Exception; end
   end

  # Debconf の質問項目を表現するクラス
  class Question
    # Question の '名前' => インスタンス の Hash
    QUESTIONS = {}
    # Very trivial items that have defaults that will work
    # in the vast majority of cases.
    PRIORITY_LOW      = 'low'.freeze
    # Normal items that have reasonable defaults.
    PRIORITY_MEDIUM   = 'medium'.freeze
    # Items that don't have a reasonable default.
    PRIORITY_HIGH     = 'high'.freeze
    # Items that will probably break the system without user intervention.
    PRIORITY_CRITICAL = 'critical'.freeze
    
    # 質問の属性を決めるブロック
    attr :actions
    # 質問の名前
    attr :name
    # 質問の Template
    attr_accessor :template
    # 質問の優先度
    attr_accessor :priority
    # 次の質問
    attr_accessor :next_question
    # 最初の質問であるかどうかを表す
    attr_accessor :first_question
    # 一つ前の質問へ戻る
    attr_accessor :backup
    
    # Question を lookup する。
    # もしみつかればみつかった Question を返し、みつからなければ
    # 新しい Question を new して返す。
    public
    def self.lookup( questionNameString )
      return QUESTIONS[questionNameString] ||= self.new( questionNameString )
    end
    
    # 登録されている Question のリストを返す
    public
    def self.questions
      return QUESTIONS.values
    end
    
    # 登録されている Question オブジェクトを名前で検索する
    public
    def self.[]( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    private
    def self.define_question( nameDescription, &block )
      case nameDescription
      when String
        question = lookup( nameDescription )
        question.template = nameDescription
      when Hash
        question = lookup( nameDescription.keys[0] )
        question.template = nameDescription.keys[0]
        question.next_question = nameDescription.values[0]
      else
        raise Deft::Exception::InvalidQuestionNameException, "Question name must be a String('name') or Hash('from' => 'to')"
      end   
      return question.enhance( &block )
    end
    
    # 登録されている Question オブジェクトをクリアする
    public
    def self.clear
      QUESTIONS.clear
    end
    
    # Question が定義されていればそれを返し、そうでなければ nil を返します
    public
    def self.question_defined?( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    # Question オブジェクトの各属性をセットする
    public
    def enhance( &block )
      @actions << block if block_given?
      @actions.each { |each| result = each.call( self ) }
      register_concrete_state
      return self
    end
    
    # あたらしい Question オブジェクトを返す
    public
    def initialize( nameString )
      @priority = nil
      @actions = []
      @name = nameString
    end
           
    private
    def register_concrete_state
      define_concrete_state
      concrete_state = eval( "#{state_class_name}.instance" )
      concrete_state.enhance( self )
    end   

    #--
    # FIXME: 'lucie-client/compile/g++' => Deft::State::LucieClient__Compile__G++ となり '++' でコンパルエラー
    #++
    private 
    def define_concrete_state
      eval( "class #{state_class_name} < Deft::State; end" )
      if @backup
        concrete_state_class.__send__( :define_method, :transit, State.instance.method(:transit_backup) )
      elsif @next_question.nil?
        concrete_state_class.__send__( :define_method, :transit, State.instance.method(:transit_finish) )
      else   
        case @next_question
        when String
          concrete_state_class.__send__( :define_method, :transit, State.instance.method(:transit_string_state) )
        when Hash
          concrete_state_class.__send__( :define_method, :transit, State.instance.method(:transit_hash_state) )
        when Proc
          concrete_state_class.__send__( :define_method, :transit, State.instance.method(:transit_proc_state) )
        else
          raise Deft::Exception::InvalidNextQuestionTypeException, "Unsupported next_question type: #{@next_question}"
        end
      end
    end
        
    private
    def concrete_state_class
      return eval(state_class_name)
    end
    
    # 質問名 => concrete state クラス名へ変換
    # 
    # 例 : 'lucie/hello-world' => 'Deft::State::Lucie__HelloWorld'
    #
    public
    def state_class_name
      return 'Deft::State::' + name.gsub('-', '_').split('/').map do |each|
        each.to_pascal_style
      end.join('__')
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
