# $Id$

require 'lmp'
require 'rexml/document'


class Question


  attr_reader :choices


  public
  def initialize( stateElement, aTemplate )
    check_arguments stateElement, aTemplate
    @choices = []
    @state_element = stateElement
    @template = aTemplate
    define_instance_specific_methods
  end


  #
  # ���� State ��Ԃ�
  #
  # FIXME : LMP::question2state �� Question �N���X�Ɏ������ׂ��H
  #
  public
  def next( choiceString = nil )
    return send( choice2method_name(choiceString) ) if choiceString
    return nil if @state_element.attributes['next'].nil?
    context_class_name + '::' +  LMP::question2state( @state_element.attributes['next'] )
  end


  #
  # ����̖��O��Ԃ�
  #
  public
  def name
    @state_element.attributes['question']
  end


  #
  # �e���v���[�g�̃^�C�v�ɉ����āA"HelloWorld < NoteState" �̂悤�� ConcreteClass ��`�̕�������������B
  #
  public
  def klass
    _klass = LMP::string2pascal_style( name.split(/\//)[1] )
    super_klass = @template[name][:super_class]
    "#{_klass} < #{super_klass}"
  end


  # FIXME : Generator �N���X���瓾��B
  private
  def context_class_name
    'DebconfContext'
  end


  private
  def choice2method_name( choiceString )
    choiceString.downcase.gsub('-', '_')
  end


  private
  def choice( caseElement )
    caseElement.attributes['value']
  end


  private
  def check_arguments( stateElement, aTemplate )
    raise ArgumentError, "First argument must be a REXML::Element." unless stateElement.kind_of?( REXML::Element )    
    raise ArgumentError, "Second argument must be a Template." unless aTemplate.kind_of?( Template )
    raise RuntimeError, "Attribute 'question' not set." if stateElement.attributes['question'].nil?
  end


  # �I���� (case �G�������g) �� next �A�g���r���[�g������킷 String ��Ԃ��A���ك��\�b�h���`����B
  # ����Ȃ��񂶁�
  # 
  # def self.i_love_you
  #   'DebconfContext::YOU_LOVE_ME_STATE'
  # end
  #
  private
  def define_instance_specific_methods
    @state_element.elements.each { |each|
      method_name = choice2method_name( choice(each) )
      eval LMP::unindent_auto(<<-METHOD)
      def self.#{method_name}
        context_class_name + '::' + \
	LMP::question2state( @state_element.elements["case[@value='#{choice(each)}']"].attributes['next'] )
      end
      METHOD
      @choices << choice(each)
    }
  end


end


#
# XML �ɂ���ԑJ�ڕ\���� State �p�^�[���̊e ConcreteState �N���X�𐶐�����B
# �e ConcreteState �͓��كI�u�W�F�N�g�ɂ���\��B
#
# FIXME: multiselect �̃T�|�[�g
#


# 
# Abstract State �N���X�B
#
class State
  include LMP

  
  PRIORITY_LOW = 'low'.freeze
  PRIORITY_MEDIUM = 'medium'.freeze
  PRIORITY_HIGH = 'high'.freeze
  PRIORITY_CRITICAL = 'critical'.freeze


  private
  def supported_priorities
    [ PRIORITY_LOW, PRIORITY_MEDIUM, PRIORITY_HIGH, PRIORITY_CRITICAL ]
  end

  
  private
  def valid_priority?( priorityString )
    supported_priorities.include? priorityString
  end


  #
  # �����炵�� State ���������B
  # 
  public
  def initialize( questionString, priorityString )
    raise "Unsupported priority : #{priorityString}" unless valid_priority?( priorityString )
    raise ArgumentError, "First argument must be a String." unless questionString.kind_of?( String )
    
    @question = questionString
    @priority = priorityString
  end


  #
  # ���� State �ɑJ�ڂ���
  #
  public
  def transit( aDebconfContext )
    raise NotImplementedError, 'abstract method'
  end


  #
  # Ruby �̃X�N���v�g��Ԃ�
  # 
  public
  def self.marshal( aQuestion )
    raise NotImplementedError, 'abstract method'
  end


  def self.concrete_class_statement( questionString, aTemplate )
    klass = LMP::string2pascal_style( questionString.split(/\//)[1] )
    super_klass = aTemplate[questionString][:super_class]
    "#{klass} < #{super_klass}"
  end
  private_class_method :concrete_class_statement


end


class NoteState < State


  public
  def self.marshal( aQuestion )
    current_state = aQuestion.next ? aQuestion.next : 'nil'

    LMP::unindent_auto(<<-CLASS_DEFINITION)
    class #{aQuestion.klass}

	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = #{current_state}
      end


    end
    CLASS_DEFINITION
  end
	  

  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


class TextState < State


  public
  def self.marshal( aQuestion )
    current_state = aQuestion.next ? aQuestion.next : 'nil'

    LMP::unindent_auto(<<-CLASS_DEFINITION)
    class #{aQuestion.klass}
      
	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = #{current_state}
      end


    end
    CLASS_DEFINITION
  end


  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


class StringState < State


  public
  def self.marshal( aQuestion )
    current_state = aQuestion.next ? aQuestion.next : 'nil'

    LMP::unindent_auto(<<-CLASS_DEFINITION)
    class #{aQuestion.klass}

	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = #{current_state}
      end


    end
    CLASS_DEFINITION
  end


  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


class PasswordState < State
  

  public
  def self.marshal( aQuestion )
    current_state = aQuestion.next ? aQuestion.next : 'nil'

    LMP::unindent_auto(<<-CLASS_DEFINITION)
    class #{aQuestion.klass}

	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = #{current_state}
      end


    end
    CLASS_DEFINITION
  end


  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


class BooleanState < State


  public
  def self.marshal( aQuestion )
    LMP::unindent_auto(<<-CLASS_DEFINITION)
    class #{aQuestion.klass}

	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = \\
	case get( @question )
	when 'true'
	  #{aQuestion.next('yes')}
	when 'false'
	  #{aQuestion.next('no')}
	else
	  raise "This shouldn't happen."
	end
      end


    end
    CLASS_DEFINITION
  end


  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


class SelectState < State


  public
  def self.marshal( aQuestion )
    whens = ''
    aQuestion.choices.each { |each|
      whens += "        when '#{each}'\n"
      whens += "          #{aQuestion.next(each)}\n"
    }

    LMP::unindent_auto( <<-CLASS_DEFINITION )
    class #{aQuestion.klass}

	    
      public
      def transit( aDebconfContext )
	super aDebconfContext
	aDebconfContext.current_state = \\
	case get( @question )
#{whens.chomp}
	else
          raise "This shouldn't happen."
        end
      end


    end
    CLASS_DEFINITION
  end


  public
  def transit( aDebconfContext )
    input @priority, @question
    go
  end


end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
