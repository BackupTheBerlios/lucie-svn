#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/password-template'
require 'deft/multiselect-template'
require 'deft/string-template'
require 'deft/boolean-template'
require 'deft/note-template'
require 'deft/select-template'
require 'deft/text-template'
require 'forwardable'
require 'lucie/string'
require 'time-stamp'

update(%q$LastChangedDate$)

# �V�����e���v���[�g��o�^���܂�
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft
  module Exception
    class UnknownTemplateTypeException < ::Exception; end
    class InvalidAttributeException < ::Exception; end
  end
     
  # Debconf �p templates �t�@�C���𐶐����� Template ���`����B
  #
  # Example:
  #
  #   require 'deft/template'
  #
  #   include Deft
  #   template( 'lucie/overview' ) do |template|
  #     template.type = 'text'
  #     template.description_ja = (<<-DESCRIPTION)
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
  class Template
    extend Forwardable
    
    TEMPLATES = {}
    
    attr_reader :name
    def_delegator :@template, :extended_description_ja=
    def_delegator :@template, :extended_description_ja        
    def_delegator :@template, :short_description_ja=
    def_delegator :@template, :short_description_ja
    def_delegator :@template, :extended_description=
    def_delegator :@template, :extended_description 
    def_delegator :@template, :short_description=
    def_delegator :@template, :short_description    
    def_delegator :@template, :choices=
    def_delegator :@template, :choices
    def_delegator :@template, :default= 
    def_delegator :@template, :default
    def_delegator :@template, :template_type=
    def_delegator :@template, :template_type     
    
    # �e���v���[�g�𖼑O�ŒT���B������Ȃ��ꍇ�ɂ� nil ��Ԃ��B
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template ����`����Ă���Β�`����Ă���e���v���[�g�A�����łȂ���� nil ��Ԃ��B
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end
    
    private
    def register
      @actions.each { |each| result = each.call( self ) }
      puts "Template #{@name} (#{@template_type}) ��o�^" if $trace
      if @template     
        TEMPLATES[@name] = @template      
        return @template
      else
        return self
      end
    end
    
    # �o�^����Ă���e���v���[�g�̃��X�g��Ԃ�
    public
    def self.templates
      return TEMPLATES.values
    end
    
    # ���ݓo�^����Ă��� Template ���N���A����
    public
    def self.clear
      TEMPLATES.clear
    end
    
    private
    def self.define_template( nameString, &block )
      template = lookup( nameString )      
      return template.enhance( &block )
    end
    
    # Template �� lookup ���A�������łɓ����� Template �����݂���΂����Ԃ��B
    # ���݂��Ȃ��ꍇ�A�V���ɓo�^����B
    public
    def self.lookup( nameString )
      return TEMPLATES[nameString] ||= self.new( nameString )
    end
    
    public
    def template_type=( templateTypeString )
      template_table = { 'text'        => Deft::TextTemplate,
                         'select'      => Deft::SelectTemplate,
                         'note'        => Deft::NoteTemplate,
                         'boolean'     => Deft::BooleanTemplate,
                         'string'      => Deft::StringTemplate,
                         'multiselect' => Deft::MultiselectTemplate,
                         'password'    => Deft::PasswordTemplate }
      if template_table[templateTypeString].nil?
        raise Exception::UnknownTemplateTypeException, templateTypeString
      end
      @template = template_table[templateTypeString].new( @name )
    end
    
    # �����炵�� Template �I�u�W�F�N�g��Ԃ�
    public
    def initialize( nameString )
      @actions = []
      @name = nameString
    end
    
    # �e���v���[�g���u���b�N��p���ăG���n���X����Bself ��Ԃ��B
    public
    def enhance( &block )
      @actions << block if block_given?
      return register
    end
    
    # �f�o�b�O�p
    public
    def inspect
      return "#<Deft::Template: @name=\"#{@name}\">"
    end
  end
end
  
### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
