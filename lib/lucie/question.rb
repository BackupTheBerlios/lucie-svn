#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/template'
require 'lucie/time-stamp'

# 新しい質問項目を登録します
def question( nameString, &block )
  return Lucie::Question.define_question( nameString, &block )
end

module Lucie
  
  update(%q$LastChangedDate$)
  
  # Debconf の質問項目を表現するクラス
  class Question
    QUESTIONS = {}
    # Very trivial items that have defaults that will work in the vast majority of cases.
    PRIORITY_LOW      = 'LOW'.freeze
    # Normal items that have reasonable defaults.
    PRIORITY_MEDIUM   = 'MEDIUM'.freeze
    # Items that don't have a reasonable default.
    PRIORITY_HIGH     = 'HIGH'.freeze
    # Items that will probably break the system without user intervention.
    PRIORITY_CRITICAL = 'CRITICAL'.freeze
    
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

    # 質問項目をあらわすクラス名の定義部分を返す
    # 例: 'PackageInformation < TextState'
    public
    def klass
      return @name.split(/\//)[1].to_pascal_style + ' < ' + @question_type.to_s
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
