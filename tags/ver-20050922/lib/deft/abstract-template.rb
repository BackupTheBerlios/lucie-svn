#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/string'
require 'deft/time-stamp'

module Deft
  update(%q$Id$)

  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

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
  # �����ϰʲ����ͤˤʤ�ޤ���
  #
  #   question( ����̾ ) do |question|
  #     question.priority = ͥ����
  #     question.first_question = �ǽ�μ��䤫�ɤ���
  #     question.next_question = ���μ���
  #   end
  #
  # next_question ��ʲ��η����ǽ񤯤��Ȥˤ�ä��������ľ��Ū�ˤ狼��
  # �䤹�����뤳�Ȥ�Ǥ��ޤ������ (=>) ������ޤ�������ϼºݤˤϥϥ�
  # ���������Ǥ���
  #
  #   question( ����̾ => ���μ��� ) do |question|
  #     question.priority = ͥ����
  #     question.first_question = �ǽ�μ��䤫�ɤ���
  #   end
  #
  #
  # �ѿ��μ��°���ˤϰʲ��Τ�Τ�����ޤ���
  #
  # * priority : �����ͥ���١����Ѳ�ǽ������� Question ���饹���������Ƥ��ޤ���
  # * next_question : ���μ��䡣
  # * first_question : �ǽ�μ���Ǥ����硢true �����ꤷ�ޤ���
  #
  # == ��å�������ɽ�� - text �ƥ�ץ졼��
  #
  # text ���Υƥ�ץ졼�Ȥ��Ѥ��뤳�Ȥˤ�äơ��桼���إ�å�������ɽ
  # �����뤳�Ȥ��Ǥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/text-template.png
  #
  #   template( 'example/text' ) do |template|
  #     template.template_type = 'text'
  #     template.short_description_ja = '����ˤ��� deft'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     text �ƥ�ץ졼�ȤǤϥ桼���ˤʤ�餫�ξ����ɽ�����뤳�Ȥ��Ǥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # text ���Υƥ�ץ졼�ȤǤϡ��ץ�ѥƥ� template_type �� 'text' ���
  # �ꤷ�ޤ���
  #
  # ���Υƥ�ץ졼�Ȥ򸵤ˤ����ѿ� lucie-vmsetup/hello ������ϰʲ���
  # �褦�ˤʤ�ޤ���
  #
  #   question( 'example/text' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/bye'
  #   end
  #
  # == ��å�������ɽ�������᡼������� - note �ƥ�ץ졼��
  #
  # �������ʤɤȤ��ä��Ȥ��˽��פʥ�å�������ɽ�������ޤ���ޥ����
  # �Ȥ��ƥ᡼������������硢note ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/note-template.png
  #
  # ����Ū�ˤ� text ���Υƥ�ץ졼�Ȥ��Ѥ�餺������ note �ˤʤ�����Ǥ���
  #
  #   template( 'example/note' ) do |template|
  #     template.template_type = 'note'
  #     template.short_description_ja = '���פʾ���'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     note �ƥ�ץ졼�ȤǤϥ桼���ˤʤ�餫�ν��פʾ����ɽ�����뤳�Ȥ��Ǥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ�������� text �ƥ�ץ졼�Ȥ�Ʊ���Ǥ���
  #
  #   question( 'example/note' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/bye'
  #   end
  #
  # == YES/NO �μ����ɽ�� - boolean �ƥ�ץ졼��
  #
  # �֥ϥ��ס֥������פ������������μ���Ǥϡ�boolean ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/boolean-template.png
  #
  #   template( 'example/boolean' ) do |template|
  #     template.template_type = 'boolean'
  #     template.default = 'true'
  #     template.short_description_ja = '���ʤ��������Ǥ��� ?'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #      boolean �ƥ�ץ졼�ȤǤ� YES/NO �����μ����ɽ���Ǥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ��ϰʲ��Τ褦�ˤʤ�ޤ���next_question ���ȥ�ӥ塼�Ȥλ���Ǥϡ�
  # true/false ����������Τ��줾����������ϥå���ǻ��ꤷ�ޤ���
  #
  #   question( 'example/boolean' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = { 'true'  => 'example/male',
  #                                'false' => 'example/female' }
  #   end
  #
  # == ʸ��������� - string �ƥ�ץ졼��
  #
  # �桼���ˤʤ�餫�����Ϥ򤦤ʤ�������μ���Ǥϡ�string ���Υƥ��
  # �졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/string-template.png
  #
  #   template( 'example/string' ) do |template|
  #     template.template_type = 'string'
  #     template.short_description_ja = '���ʤ��Τ�̾�������Ϥ��Ƥ�������'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     string �ƥ�ץ졼�ȤǤ�Ǥ�դ�ʸ��������ϤǤ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ�����Ǥ��ä����̤����Ϥ���ޤ���
  #
  #   question( 'example/string' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/display_your__name'
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
  #     question.next_question = { 'blue' => 'example/blue',    # �桼�����Ϥ˱�����������򿶤�ʬ��
  #                                'white' => 'example/white', 
  #                                'yellow' => 'example/yellow', 
  #                                'red' => 'example/red' }
  #   end
  #
  # == �������椫��ʣ������ - multiselect �ƥ�ץ졼��
  #
  # �������椫��ʣ�������Ф������μ���Ǥϡ�multiselect ���Υƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/multiselect-template.png
  #
  # �ƥ�ץ졼������� select �ƥ�ץ졼�Ȥ�Ʊ���Ǥ�
  #
  #   template( 'example/multiselect' ) do |template|
  #     template.template_type = 'multiselect'
  #     template.choices = ['blue', 'white', 'yellow', 'red'] # ���������
  #     template.short_description_ja = '���ʤ��ι����ʿ��� ? (ʣ��������)'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     multiselect �ƥ�ץ졼�ȤǤϥ桼�����������󼨤��������椫��ʣ�������Ф��뤳�Ȥ��Ǥ��ޤ���
  #     DESCRIPTION_JA
  #   end
  #
  # �ѿ�����Ǥ� next_question °���� proc ���֥������Ȥ���ꤹ�뤳��
  # �ˤ�äơ��桼�����Ϥ˱�������������Ѳ������뤳�Ȥ��Ǥ��ޤ���
  #
  #   question( 'example/multiselect' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.first_question = true 
  #     question.next_question = proc do |user_nput| # �桼�����Ϥ˱�����������򿶤�ʬ��
  #       # �ѿ� user_input ���������� ('blue, yellow' �ʤɤ�ʸ����) ������
  #       # ɬ�פ˱����ơ�user_input �˱�����������򿶤�ʬ����������
  #       'example/next' # proc ��ɾ���ͤ�����������Ȥʤ�
  #     end
  #   end
  #
  # == �ѥ���ɤ����� - password �ƥ�ץ졼��
  #
  # �ѥ���ɤʤɤε�̩��������Ϥ��������μ���Ǥϡ�password �ƥ�ץ졼�Ȥ��Ѥ��ޤ���
  #
  # http://lucie.sourceforge.net/images/password-template.png
  #
  # �������Ƥ����٤� '*' �ǥޥ�������뤿�ᡢstring �ƥ�ץ졼�ȤȰ㤤
  # ��߸����뿴�ۤ�����ޤ���
  #
  # �ƥ�ץ졼��������ѿ�����Ϥۤ� string �ƥ�ץ졼�Ȥ�Ʊ���Ǥ���
  #
  #   template( 'example/password' ) do |template|
  #     template.template_type = 'password'
  #     template.short_description_ja = 'root �ѥ���ɤ����Ϥ��Ƥ�������'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     password �ƥ�ץ졼�ȤǤϥѥ���ɤʤɤε�̩��������ϤǤ��ޤ���
  #     string �ƥ�ץ졼�ȤȤΰ㤤�ϡ��������Ƥ��������Хå�����ʤ����Ǥ���
  #     DESCRIPTION_JA
  #   end
  #
  #  question( 'example/password' ) do |question|
  #    question.priority = Deft::Question::PRIORITY_MEDIUM
  #    question.next_question = 'example/root_login'
  #  end
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
    
    # �����ǽ�ʹ��ܤ� String �⤷���� Array �ǰʲ��Τ褦�˻��ꤹ�롣
    #
    #   aTemplate.choices = ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #   aTemplate.choices = "CHOICE 1, CHOICE 2, CHOICE 3"
    #
    public
    def choices=( _choices )
      type_check( "Choice", _choices, Array, String )
      case _choices
      when Array
        @choices = _choices
      when String
        @choices = _choices.split(/\s*,\s*/)
      end
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
      type_check( "Default", defaultString, String )
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
      type_check( "Short description", descriptionString, String )
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
      type_check( "Short description JA", descriptionString, String )
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
      type_check( "Extended description JA", descriptionString, String )
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
      type_check( "Extended description", descriptionString, String )
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
    def type_check( attribute,  actualValue, *types )
      unless( types.any? do |each| actualValue.is_a?( each ) end )
        types_string = (types.map do |each| each.to_s end).join('/')
        raise Exception::InvalidAttributeException, "#{attribute} must be an #{types_string} object."
      end
    end

    private
    def template_string( typeString, *optionalFieldsArray )     
      _template_string =  "Template: #{name}\n"
      _template_string += "Type: #{typeString}\n"
      if optionalFieldsArray.include?( 'choices' ) && choices
        _template_string += "Choices: #{choices.join(', ')}\n" 
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
