#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/state'
require 'deft/template'
require 'time-stamp'

# �V�������⍀�ڂ�o�^����
def question( nameString, &block )
  return Deft::Question.define_question( nameString, &block )
end

update(%q$LastChangedDate$)

module Deft
  # Debconf �̎��⍀�ڂ�\������N���X
  class Question
    # Question �� '���O' => �C���X�^���X �� Hash
    QUESTIONS = {}
    # Very trivial items that have defaults that will work in the vast majority of cases.
    PRIORITY_LOW      = 'low'.freeze
    # Normal items that have reasonable defaults.
    PRIORITY_MEDIUM   = 'medium'.freeze
    # Items that don't have a reasonable default.
    PRIORITY_HIGH     = 'high'.freeze
    # Items that will probably break the system without user intervention.
    PRIORITY_CRITICAL = 'critical'.freeze
    
    # ����̑��������߂�u���b�N
    attr :actions
    # ����̖��O
    attr :name
    # ����� Template
    attr_accessor :template
    # ����̗D��x
    attr_accessor :priority
    # ���̎���
    attr_accessor :next_question
    # �ŏ��̎���ł��邩�ǂ�����\��
    attr_accessor :first_question
    attr_accessor :backup
    
    # Question �� lookup ����B
    # �����݂���΂݂����� Question ��Ԃ��A�݂���Ȃ���ΐV���� Question �� new ���ĕԂ��B
    public
    def self.lookup( questionNameString )
      return QUESTIONS[questionNameString] ||= self.new( questionNameString )
    end
    
    # �o�^����Ă��� Question �̃��X�g��Ԃ�
    public
    def self.questions
      return QUESTIONS.values
    end
    
    # �o�^����Ă��� Question �I�u�W�F�N�g�𖼑O�Ō�������
    public
    def self.[]( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    private
    def self.define_question( nameDescription, &block )
      case nameDescription
      when String
        question = lookup( nameDescription )
        question.template = Template[nameDescription] 
      when Hash
        question = lookup( nameDescription.keys[0] )
        question.template = Template[nameDescription.keys[0]] 
        question.next_question = nameDescription.values[0]
      else
        raise "This shouldn't happen"
      end   
      return question.enhance( &block )
    end
    
    # �o�^����Ă��� Question �I�u�W�F�N�g���N���A����
    public
    def self.clear
      QUESTIONS.clear
    end
    
    # Question ����`����Ă���΂����Ԃ��A�����łȂ���� nil ��Ԃ��܂�
    public
    def self.question_defined?( questionNameString )
      return QUESTIONS[questionNameString]
    end
    
    # Question �I�u�W�F�N�g�̊e�������Z�b�g����
    public
    def enhance( &block )
      @actions << block if block_given?
      @actions.each { |each| result = each.call( self ) }
      register_concrete_state
      puts "Question #{@name} (�e���v���[�g : #{@template.name}) ��o�^" if $trace
      return self
    end
    
    # �����炵�� Question �I�u�W�F�N�g��Ԃ�
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

    private 
    def define_concrete_state
      eval( "class #{state_class_name} < Deft::State; end" )
      if @backup
        concrete_state_class.__send__( :define_method, :transit, 
                                       State.instance.method(:transit_backup) )
      elsif @next_question.nil?
        concrete_state_class.__send__( :define_method, :transit, 
                                       State.instance.method(:transit_finish) )
      else   
        case @next_question
        when String
          concrete_state_class.__send__( :define_method, :transit, 
                                         State.instance.method(:transit_string_state) )
        when Hash
          concrete_state_class.__send__( :define_method, :transit, 
                                         State.instance.method(:transit_hash_state) )
        when Proc
          concrete_state_class.__send__( :define_method, :transit, 
                                         State.instance.method(:transit_proc_state) )
        else
          raise "Unsupported next_question: #{@next_question}"
        end
      end
    end
        
    private
    def concrete_state_class
      return eval(state_class_name)
    end
    
    # ���▼ => concrete state �N���X���֕ϊ�
    # 
    # �� : 'lucie/hello-world' => 'Deft::State::Lucie__HelloWorld'
    #
    public
    def state_class_name
      return 'Deft::State::' + name.gsub('-', '_').split('/').map do |each|
        each.to_pascal_style
      end.join('__')
    end
    
    # TODO: need to implement Exception & Error using exception
    module Exception
      class InvalidQuestionException < ::Exception; end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
