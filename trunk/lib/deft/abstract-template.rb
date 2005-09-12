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

  #--
  # FIXME: �ʲ����㤬ʿ�פǤʤ��Τǿ��������ͤ��롣
  #++
  #
  # == �ƥ�ץ졼�Ȥδ���
  #
  # Debconf �ˤϡ��֥ƥ�ץ졼�ȡפȡ��ѿ��פȸƤФ�복ǰ������ޤ���
  # ���̤�ɽ�������Ƽ�����̤ϼ������Ƥ�������������Ǥ���ƥ�ץ졼
  # �Ȥ��Ȥˤ�����������ޤ����桼���� Debconf ���̤������Ϥ�������
  # ���ѿ�����������ޤ���Debconf ���Ѥ���������������γ�ȯ�Ǥϡ���
  # ���桼����ɽ��������������ܤ�ꥹ�ȥ��åפ����Ƽ�����ܤ��б�����
  # �ƥ�ץ졼�Ȥ��ѿ����������ɬ�פ�����ޤ���
  #
  # Debconf �λ��ͤˤĤ��Ƥ��ܤ����� {Configuration Management Protocol Version 2}[http://www.debian.org/doc/packaging-manuals/debconf_specification.html] 
  # �򻲾Ȥ��Ƥ���������
  # 
  # === �ƥ�ץ졼��
  # 
  # �ƥ�ץ졼�Ȥϥ桼����ɽ�����������ܤο�������ꤹ���ΤǤ�����
  # ��ץ졼�Ȥμ��°���ˤ�̾���������ǥե�����͡�����������ޤ�
  #
  #   Template: ̾��
  #   Type: ��
  #   Default: �ǥե������
  #   Description: û��������
  #    Ĺ������
  #
  # �� (Type: �ե������) �ϼ���μ������ꤷ�ޤ�������μ���ˤϰʲ�
  # ������ޤ���
  #
  # * string: ʸ��������Ϥ��������
  # * boolean: true �� false �����Ф������
  # * select: ʣ�����ܤ����Ĥ����Ф������
  # * multiselect: ʣ�����ܤ���ʣ�������Ф������
  # * text: �桼���ؾ����ɽ������
  # * note: �桼���ؾ����ɽ�����᡼�������
  # * password: �ѥ���ɤʤɵ�̩��������Ϥ��������
  #
  # === �ѿ�
  #
  # �ѿ��ϥƥ�ץ졼�Ȥ�����������ޤ����ƥ�ץ졼�Ȥǻؼ����줿������
  # ��������Ȥäƥ桼���˼����ɽ���������η�̤򵭲����Ƥ����Τ��ѿ�
  # �Ǥ����ҤȤĤ��ѿ��ϤҤȤĤμ�����̤��б����ޤ�������Ū�ˤϥƥ��
  # �졼�Ȥ��ѿ��� 1 �� 1 ���б����Ƥ��ޤ������ҤȤĤΥƥ�ץ졼�Ȥ���
  # ʣ�����ѿ�������������줾��˰ۤʤä��� (�桼������) ���ݻ����뤳
  # �Ȥ�Ǥ��ޤ���
  #
  # === ��������
  #
  # ��ȯ�Ԥϥƥ�ץ졼�Ȥ��ѿ��˲ä����桼�����Ϥ˱��������̴֤����ܤ�
  # ���Ҥ���ɬ�פ�����ޤ���
  #
  # == ��å�������ɽ�� - text �ƥ�ץ졼��
  #
  # text ���Υƥ�ץ졼�Ȥ��Ѥ��뤳�Ȥˤ�äơ��桼���إ�å�������ɽ
  # �����뤳�Ȥ��Ǥ��ޤ���
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot1.png
  #
  # �ʲ��� text ���ƥ�ץ졼�� lucie-vmsetup/hello ����Ǥ���
  #
  #   template( 'lucie-vmsetup/hello' ) do |template|
  #     template.template_type = 'text'
  #     template.short_description_ja = 'Lucie VM �Υ��åȥ��åץ��������ɤؤ褦����'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     ���Υ��������ɤǤϡ�Lucie ���Ѥ��� VM ���åȥ��åפ���������Ϥ��ޤ���
  #     �����ǽ�ʹ��ܤϡ�
  #      o ɬ�פ� VM �����
  #      o �����ͥåȥ���ؤ���³
  #      o VM �ǻ��Ѥ����������
  #      o VM �ǻ��Ѥ���ϡ��ɥǥ���������
  #      o ���Ѥ��� VM �μ���
  #      o VM �إ��󥹥ȡ��뤹�� Linux �ǥ����ȥ�ӥ塼�����μ���
  #      o VM �إ��󥹥ȡ��뤹�륽�եȥ������μ���
  #     �Ǥ�����ʬ�� VM ������餻��������֤������ˤ�ä��������Ƥ���������
  #  
  #     �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # text ���Υƥ�ץ졼�ȤǤϡ��ץ�ѥƥ� template_type �� 'text' ���
  # �ꤷ�ޤ���
  #
  # ���ˡ����Υƥ�ץ졼�Ȥ򸵤ˤ����ѿ� lucie-vmsetup/hello �������
  # �ޤ���
  #
  #   question( 'lucie-vmsetup/hello' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = 'lucie-vmsetup/num-nodes'
  #     question.first_question = true
  #   end
  #
  # question �γƥץ�ѥƥ��ΰ�̣�ϰʲ����̤�Ǥ���
  #
  # * priority : �����ͥ���١����Ѳ�ǽ������� Question ���饹���������Ƥ��ޤ���
  # * next_question : ���μ��䡣
  # * first_question : �ǽ�μ���Ǥ����硢true �����ꤷ�ޤ���
  #
  # == ��å�������ɽ�������᡼������� - note �ƥ�ץ졼��
  #
  # �������ʤɤȤ��ä��Ȥ��˽��פʥ�å�������ɽ�������ޤ���ޥ����
  # �Ȥ��ƥ᡼������������硢note ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot1.png
  #
  # ����Ū�ˤ� text ���Υƥ�ץ졼�Ȥ��Ѥ�餺������ note �ˤʤ�����Ǥ���
  #
  #   template( 'lucie-vmsetup/hello' ) do |template|
  #     template.template_type = 'note'
  #     template.short_description_ja = 'Lucie VM �Υ��åȥ��åץ��������ɤؤ褦����'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     ���Υ��������ɤǤϡ�Lucie ���Ѥ��� VM ���åȥ��åפ���������Ϥ��ޤ���
  #     �����ǽ�ʹ��ܤϡ�
  #      o ɬ�פ� VM �����
  #      o �����ͥåȥ���ؤ���³
  #      o VM �ǻ��Ѥ����������
  #      o VM �ǻ��Ѥ���ϡ��ɥǥ���������
  #      o ���Ѥ��� VM �μ���
  #      o VM �إ��󥹥ȡ��뤹�� Linux �ǥ����ȥ�ӥ塼�����μ���
  #      o VM �إ��󥹥ȡ��뤹�륽�եȥ������μ���
  #     �Ǥ�����ʬ�� VM ������餻��������֤������ˤ�ä��������Ƥ���������
  #
  #     �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ��ν����� text ���ξ���Ʊ���Ǥ���
  #
  # == YES/NO �μ����ɽ�� - boolean �ƥ�ץ졼��
  #
  # �֥ϥ��ס֥������פ������������μ���Ǥϡ�boolean ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot3.png
  #
  #   template( 'lucie-vmsetup/use-network' ) do |template|
  #     template.template_type = 'boolean'
  #     template.default = 'false'
  #     template.short_description_ja = 'VM �γ����ͥåȥ���ؤ���³'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     ����ּ¹Ի��� VM �ϳ����ͥåȥ������³����ɬ�פ�����ޤ�����
  #     ���Υ��ץ����򥪥�ˤ���ȡ�GRAM ����ưŪ�˳� VM ��Ϣ³���� IP ���ɥ쥹�� MAC ���ɥ쥹�������ơ�
  #     Lucie �򤹤٤ƤΥͥåȥ���ط��������Ԥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ��ϰʲ��Τ褦�ˤʤ�ޤ���next_question ���ȥ�ӥ塼�Ȥλ���Ǥϡ�
  # true/false ����������Τ��줾����������ϥå���ǻ��ꤷ�ޤ���
  #
  #   question( 'lucie-vmsetup/use-network' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
  #   end  
  #
  # == ʸ��������� - string �ƥ�ץ졼��
  #
  # �桼���ˤʤ�餫�����Ϥ򤦤ʤ�������μ���Ǥϡ�string ���Υƥ��
  # �졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot9.png
  #
  #   template( 'lucie-vmsetup/application' ) do |template|
  #     template.template_type = 'string'
  #     template.short_description_ja = '���Ѥ��륢�ץꥱ�������'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��륽�եȥ������ѥå����������Ϥ��Ƥ�������
  #
  #     ������ PrestoIII ���饹���ǥǥե���Ȥǥ��󥹥ȡ��뤵��륽�եȥ������ѥå������ϰʲ����̤�Ǥ���
  #      o ���ܥѥå�����: fileutils, findutils �ʤɤδ���Ū�ʥ桼�ƥ���ƥ�
  #      o ������: tcsh, bash, zsh �ʤɤΥ�����
  #      o �ͥåȥ���ǡ����: ssh �� rsh, ftp �ʤɤΥǡ����
  #     �嵭���ɲä��ƥ��󥹥ȡ��뤷�����ѥå������򥳥�޶��ڤ�����Ϥ��Ƥ���������
  #
  #     ��: ruby, python, blast2
  #     DESCRIPTION_JA
  #   end
  #
  # == �������椫���Ĥ������� - select �ƥ�ץ졼��
  #
  # �������椫��ҤȤĤ����Ф������μ���Ǥϡ�select ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/select-template.png
  #
  # �ƥ�ץ졼������Ǥϡ�choices �ץ�ѥƥ�����������ꤷ�Ƥ��뤳��
  # �����ܤ��Ƥ���������
  #
  #   template( 'example/select' ) do |template|
  #     template.template_type = 'select'
  #     template.choices = ['blue', 'white', 'yellow', 'red'] # ���������
  #     template.short_description_ja = '���ʤ��ι����ʿ��� ?'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     select �ƥ�ץ졼�ȤǤϥ桼�����������󼨤��������椫���Ĥ����Ф��뤳�Ȥ��Ǥ��ޤ���
  #
  #     ���ʤ��ι����ʿ��ϲ��Ǥ�����
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ�����Ǥ� next_question °���˥ϥå������ꤹ�뤳�Ȥˤ�äơ�
  # �桼�����Ϥ˱�������������Ѳ������뤳�Ȥ��Ǥ��ޤ���
  #
  #   question( 'example/select' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.first_question = true
  #     question.next_question = { 'blue' => 'example/blue',    # �桼�����Ϥ˱�����������򿶤�ʬ��
  #                                'white' => 'example/white', 
  #                                'yellow' => 'example/yellow', 
  #                                'red' => 'example/red' }
  #   end
  #
  # == �������椫��ʣ������ - multiselect �ƥ�ץ졼��
  #
  # ����
  #
  # == �ѥ���ɤ����� - password �ƥ�ץ졼��
  #
  # ����
  #
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
