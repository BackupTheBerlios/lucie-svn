#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/boolean-state'
require 'deft/multiselect-state'
require 'deft/note-state'
require 'deft/password-state'
require 'deft/select-state'
require 'deft/string-state'
require 'deft/text-state'
require 'lucie/template'
require 'lucie/time-stamp'

# 新しい質問項目を登録します
def question( nameString, &block )
  return Deft::Question.define_question( nameString, &block )
end

module Deft
  
  Lucie.update(%q$LastChangedDate$)
  
  # Debconf の質問項目を表現するクラス
  class Question
    QUESTIONS = {}
    # Very trivial items that have defaults that will work in the vast majority of cases.
    PRIORITY_LOW      = 'low'.freeze
    # Normal items that have reasonable defaults.
    PRIORITY_MEDIUM   = 'medium'.freeze
    # Items that don't have a reasonable default.
    PRIORITY_HIGH     = 'high'.freeze
    # Items that will probably break the system without user intervention.
    PRIORITY_CRITICAL = 'critical'.freeze
    
    attr :actions
    attr :name
    attr_accessor :template
    attr_accessor :priority
    attr_accessor :next_question
    attr_accessor :first_question
    
    # Question を lookup する。
    # もしみつかればみつかった Question を返し、みつからなければ新しい Question を new して返す。
    public
    def self.lookup( questionNameString )
      return QUESTIONS[questionNameString] ||= self.new( questionNameString )
    end
    
    public
    def self.[]( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    private
    def self.define_question( nameString, &block )
      question = lookup( nameString ) 
      question.template = Lucie::Template[nameString]     
      return question.enhance( &block )
    end
    
    public
    def self.clear
      QUESTIONS.clear
    end
    
    # Question が定義されていればそれを返し、そうでなければ nil を返します
    public
    def self.question_defined?( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    # Question を登録する
    public
    def register
      puts "Question #{@name} を登録" if $trace
      @actions.each { |each| result = each.call( self ) }
    end
    
    public
    def enhance( &block )
      @actions << block if block_given?
      register
      return self
    end
    
    public
    def initialize( nameString )
      @priority = nil
      @actions = []
      @name = nameString
    end
           
    # +self+ を表す concrete state のインスタンスを返す
    public
    def concrete_state     
      eval marshal_concrete_state
      return eval( "#{state_class_name}.instance" ) 
    end   
    
    public
    def marshal_concrete_state
      return state_type.__send__( :marshal_concrete_state, self )
    end
    
    private
    def state_type
      return { StringTemplate => Deft::StringState,
        MultiselectTemplate => Deft::MultiselectState,
        SelectTemplate => Deft::SelectState,
        NoteTemplate => Deft::NoteState,
        BooleanTemplate => Deft::BooleanState }[template.class] 
    end 
    
    # 質問名 => concrete state クラス名へ変換
    # 
    # 例 : 'lucie/hello-world' => 'Lucie__HelloWorld'
    #
    public
    def state_class_name
      return 'Deft::State::' + name.gsub('-', '_').split('/').map do |each|
        each.to_pascal_style
      end.join('__')
    end
    
    ## TODO: need to implement Exception & Error using exception
    module Exception
      class InvalidQuestionException < ::Exception; end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
