#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'

require 'forwardable'
require 'lucie/string'
require 'lucie/time-stamp'

# �V�����e���v���[�g��o�^���܂�
def template( nameString, templateType, &block )
  return Lucie::Template.define_template( nameString, templateType, &block )
end

module Lucie
  
  update(%q$LastChangedDate$)
  
  # Debconf �p templates �t�@�C���𐶐����� Template ���`���܂��B
  #
  # Example:
  #
  #   template( 'lucie/overview' ) do |template|
  #     template.type = Text
  #     template.description = (<<-DESCRIPTION)
  #     ���� Lucie �ݒ�p�b�P�[�W�́A�ȉ��̃p�b�P�[�W���C���X�g�[���E�ݒ肷��悤��
  #     Lucie �̐ݒ�𐶐����܂��B
  # 
  #     �ݒ肳���p�b�P�[�W�̃��X�g�͈ȉ��̒ʂ�ł��B
  #
  #     o autoconf - automatic configure script builder
  #     o automake - A tool for generating GNU Standards-compliant Makefiles.
  #     ...
  #     DESCRIPTION
  #   end
  #
  #--
  # TODO: subst�ɂ�铮�I�e���v���[�g���� (debconf spec ���Q��) ���T�|�[�g
  #++
  class Template
    extend Forwardable
    
    attr :name
    def_delegator :@hash, :[]
    def_delegator :@hash, :size
    
    TEMPLATES = {}
    
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template ����`����Ă���Β�`����Ă���e���v���[�g�A�����łȂ���� nil ��Ԃ��܂�
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end

    private
    def register
      puts "Template #{@name} ��o�^" if $trace
      @actions.each { |each| result = each.call( self ) }
      return self
    end
      
    # �o�^����Ă���e���v���[�g�̃��X�g��Ԃ��܂�
    public
    def self.templates
      return TEMPLATES.values
    end

    # ���ݓo�^����Ă��� Template ���N���A���܂�
    public
    def self.clear
      TEMPLATES.clear
    end
    
    private
    def self.define_template( nameString, templateType, &block )
      template = lookup( nameString, templateType )
      template.enhance( &block )
      return template
    end
    
    # Template �� lookup ���A�������łɓ����� Template �����݂���΂����Ԃ��܂��B
    # ���݂��Ȃ��ꍇ�A�V���ɓo�^���܂��B
    public
    def self.lookup( nameString, templateType )
      return TEMPLATES[nameString] ||= templateType.new( nameString )
    end
    
    # template ��������p�[�X���ATemplate �I�u�W�F�N�g�̃n�b�V�� (�L�[:�e���v���[�g��) ��Ԃ��܂�
    public
    def self.parse( templateString )
      templates = {}
      templateString.split("\n\n").each do |each|
        template_hash = {}
        template_name = nil
        variable_name = nil
        each.split( "\n" ).each do |line|
          if /\A([\w\-]+): (.*)/=~ line
            if $1 == "Template"
              template_name = $2
              template_hash['Template'] = template_name
            else
              variable_name = $1
              template_hash[variable_name] = $2
            end
          elsif /\A (.*)\Z/=~ line
            template_hash[variable_name] = template_hash[variable_name] + "\n" + $1
          end
        end
        templates[template_name] = self.new( template_name, template_hash )
      end
      return templates
    end
    
    # �����炵�� Template �I�u�W�F�N�g��Ԃ�
    public
    def initialize( nameString, attributeHash = {} )
      @actions = []
      @name = nameString
      @hash = attributeHash
    end
    
    # �e���v���[�g���u���b�N��p���ăG���n���X���܂��Bself ��Ԃ��܂��B
    public
    def enhance( &block )
      @actions << block if block_given?
      register
      return self
    end
    
    # �e���v���[�g�� 'Type:' ��Ԃ��܂�
    public
    def template_type
      return self.class
    end
    
    # �e���v���[�g�� 'Choices:' ���w�肵�܂�
    public
    def choices=( choicesArray )
      @hash['Choices'] = choicesArray.join(', ')
    end
    
    # �e���v���[�g�� 'Choices:' ���w�肵�܂�
    public
    def choices
      return @hash['Choices']
    end
    
    # �e���v���[�g�� 'Description:' ���w�肵�܂�
    def description=( descriptionString )
      @hash['Description'] = descriptionString.unindent_auto
    end
    
    # �e���v���[�g�� 'Description:' ��Ԃ��܂�
    def description
      return @hash['Description']
    end

    # �e���v���[�g�� 'Description-ja:' ���w�肵�܂�
    def description_ja=( descriptionString )
      @hash['Description-ja'] = descriptionString.unindent_auto
    end
    
    # �e���v���[�g�� 'Description-ja:' ��Ԃ��܂�
    def description_ja
      return @hash['Description-ja']
    end
    
    # �e���v���[�g�� 'Default:' ���w�肵�܂�
    def default=( defaultString )
      @hash['Default'] = defaultString
    end
    
    # �e���v���[�g�� 'Default:' ��Ԃ��܂�
    def default
      return @hash['Default']
    end

    private
    def long_description
      return format_long_description( description )
    end

    private 
    def long_description_ja
      return format_long_description( description_ja )
    end

    private
    def short_description_ja
      description_ja.split("\n")[0]
    end

    private
    def short_description
      description.split("\n")[0]
    end

    private
    def format_long_description( descriptionString )
      return descriptionString.split("\n")[1..-1].map do |each|
        case each
        when /\A\s*\Z/
          ' .'
        else
          " #{each}"
        end
        end.join("\n")
      end
    end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
