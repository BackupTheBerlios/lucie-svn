#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/template'
require 'lucie/time-stamp'

# �V�������⍀�ڂ�o�^���܂�
def question( nameString, &block )
  return Lucie::Question.define_question( nameString, &block )
end

module Lucie
  
  update(%q$LastChangedDate$)
  
  # Debconf �̎��⍀�ڂ�\������N���X
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
    
    # Question �� lookup ����B
    # �����݂���΂݂����� Question ��Ԃ��A�݂���Ȃ���ΐV���� Question �� new ���ĕԂ��B
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
    
    # Question ����`����Ă���΂����Ԃ��A�����łȂ���� nil ��Ԃ��܂�
    public
    def self.question_defined?( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    # Question ��o�^����
    public
    def register
      puts "Question #{@name} ��o�^" if $trace
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

    # ���⍀�ڂ�����킷�N���X���̒�`������Ԃ�
    # ��: 'PackageInformation < TextState'
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
