#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'time-stamp'

# FIXME: �⥸�塼��/���饹�������¦���ɤ����
update(%q$Id$)

module Deft
  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

  # ���٤ƤΥƥ�ץ졼�ȥ��饹�οƤȤʤ륯�饹���ƥ�ץ졼�Ȥγƥ��ȥ�
  # �ӥ塼�ȤؤΥ������å��᥽�å����ζ��̤���᥽�åɤ��󶡤��롣�ƥ�
  # �ץ졼�Ȥ��ɲä���Ȥ��ä����ʳ��ˤϤ��Υ��饹��ľ�ܻ��Ѥ��뤳��
  # ��̵����
  class AbstractTemplate
    # �ƥ�ץ졼�ȥ��饹̾ => �ƥ�ץ졼��̾�Υϥå���ơ��֥�
    public
    def self.template2class_table # :nodoc:
      { Deft::TextTemplate => 'text',
        Deft::SelectTemplate => 'select',
        Deft::NoteTemplate => 'note',
        Deft::BooleanTemplate => 'boolean',
        Deft::StringTemplate => 'string',
        Deft::MultiselectTemplate => 'multiselect',
        Deft::PasswordTemplate => 'password' }
    end
    
    public 
    def initialize( nameString ) # :nodoc:
      @name = nameString
    end

    # �ƥ�ץ졼��̾���֤���
    public
    def name
      return @name
    end

    # �����ǽ�ʹ��ܤ� String �� Array ���֤���
    #
    #   aTemplate.choices => ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices
      return @choices
    end
    
    # �����ǽ�ʹ��ܤ� String �� Array �ǻ��ꤹ�롣
    #
    #   aTemplate.choices = ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices=( choiceArray )
      type_check( "Choice", Array, choiceArray )
      @choices = choiceArray
    end

    # �ǥե�����ͤ� String ���֤���
    # 
    #   aTemplate.default => "DEFAULT VALUE"
    #
    public
    def default
      return @default
    end

    # �ǥե�����ͤ� String �ǻ��ꤹ�롣
    # 
    #   aTemplate.default = "DEFAULT VALUE"
    #
    public
    def default=( defaultString )
      type_check( "Default", String, defaultString )
      @default = defaultString
    end

    # û���ѥå����������� String ���֤���
    # 
    #   aTemplate.short_description => "Short description about this metapackage"
    #
    public
    def short_description
      return @short_description
    end

    # û���ѥå����������� String �ǻ��ꤹ�롣
    # 
    #   aTemplate.short_description = "Short description about this metapackage"
    #
    public
    def short_description=( descriptionString )
      type_check( "Short description", String, descriptionString )
      @short_description = descriptionString
    end

    # û���ѥå���������(���ܸ�)�� String ���֤���
    # 
    #   aTemplate.short_description_ja => "�᥿�ѥå����������ܸ�ˤ��û������"
    #
    public
    def short_description_ja
      return @short_description_ja
    end

    # û���ѥå���������(���ܸ�)�� String �ǻ��ꤹ�롣
    # 
    #   aTemplate.short_description_ja = "�᥿�ѥå����������ܸ�ˤ��û������"
    #
    public
    def short_description_ja=( descriptionString )
      type_check( "Short description JA", String, descriptionString )
      @short_description_ja = descriptionString
    end

    # Ĺ���ѥå���������(���ܸ�)�� String ���֤���
    # 
    #   aTemplate.extended_description_ja => "�᥿�ѥå����������ܸ�ˤ��Ĺ������"
    #
    public
    def extended_description_ja
      return @extended_description_ja
    end

    # Ĺ���ѥå���������(���ܸ�)�� String �ǻ��ꤹ�롣
    # 
    #   aTemplate.extended_description_ja = "�᥿�ѥå����������ܸ�ˤ��Ĺ������"
    #
    public
    def extended_description_ja=( descriptionString )
      type_check( "Extended description JA", String, descriptionString )
      @extended_description_ja = descriptionString
    end

    # Ĺ���ѥå����������� String ���֤���
    # 
    #   aTemplate.extended_description => "Extended description about this metapackage"
    #
    public
    def extended_description
      return @extended_description
    end

    # Ĺ���ѥå����������� String �ǻ��ꤹ�롣
    # 
    #   aTemplate.extended_description = "Extended description about this metapackage"
    #
    public
    def extended_description=( descriptionString )
      type_check( "Extended description", String, descriptionString )
      @extended_description = descriptionString
    end

    # �ǥХå���
    public
    def inspect # :nodoc:
      return "#<Deft::AbstractTemplate: @name=\"#{@name}\">"
    end
    
    # ʸ������Ѵ�����
    public
    def to_s # :nodoc:
      unless ( (@short_description and @extended_description) or
               (@short_description_ja and @extended_description_ja) )
        raise Exception::RequiredAttributeException
      end
    end

    # �ƥ�ץ졼��̾�� String ���֤���
    #
    #   aTemplate = Deft::TextTemplate.new( "text template" )
    #   aTemplate.template_type => 'text'
    #
    public
    def template_type
      return AbstractTemplate.template2class_table[self.class]
    end

    private
    def type_check( attribute, type, actualValue )
      unless actualValue.is_a?( type )
        raise Exception::InvalidAttributeException, "#{attribute} must be an #{type.to_s} object."
      end
    end

    private
    def template_string( typeString, *optionalFieldsArray )     
      _template_string =  "Template: #{name}\n"
      _template_string += "Type: #{typeString}\n"
      if optionalFieldsArray.include?( 'choices' ) && choices
        case choices
        when String
          _template_string += "Choices: #{choices}\n" 
        when Array
          _template_string += "Choices: #{choices.join(', ')}\n" 
        else
          raise "This shouldn't happen"
        end
      end
      _template_string += "Default: #{default}\n" if optionalFieldsArray.include?( 'default' ) && default
      _template_string += "Description: #{short_description}\n" if short_description
      _template_string += extended_description.to_rfc822 + "\n" if extended_description
      _template_string += "Description-ja: #{short_description_ja}\n" if short_description_ja
      _template_string += extended_description_ja.to_rfc822 if extended_description_ja
      return _template_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
