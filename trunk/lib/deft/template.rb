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

# �ƥ�ץ졼�Ȥ���Ͽ
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft    
  # Debconf ? templates ????????? Template ??????
  #
  # Example:
  #
  #   require 'deft/template'
  #
  #   include Deft
  #   template( 'lucie/overview' ) do |template|
  #     template.type = 'text'
  #     template.description_ja = (<<-DESCRIPTION)
  #     ?? Lucie ???????????????????????????
  #     ????? Lucie ??????????
  # 
  #     ???????????????????????
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
    
    # ???????????????????????nil ????
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template ???????????????????????
    # ??????? nil ????
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end

    # �ƥ�ץ졼�Ȥ���Ͽ
    private
    def register
      @actions.each { |each| result = each.call( self ) }
      $stderr.puts "Template #{@name} (#{@template.template_type}) ����Ͽ" if $trace
      if @template     
        TEMPLATES[@name] = @template      
        return @template
      else
        return self
      end
    end
    
    # ��Ͽ����Ƥ��� Template ��������֤�
    public
    def self.templates
      return TEMPLATES.values
    end
    
    # ��Ͽ����Ƥ��� Template �򥯥ꥢ����
    public
    def self.clear
      TEMPLATES.clear
    end
    
    # �ƥ�ץ졼�Ȥ��������
    private
    def self.define_template( nameString, &block )
      template = lookup( nameString )      
      return template.enhance( &block )
    end
    
    # ��Ͽ����Ƥ��� Template ��̾����õ��.
    # �⤷��Ͽ����Ƥ���ʪ��̵����� new ����
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
    
    # ������ Template ���֥������Ȥ��֤�
    #--
    # TODO: nameString �η���񼰤�����å� (?)
    #++
    public
    def initialize( nameString )
      @actions = []
      @name = nameString
    end
    
    # Template ��°����֥�å��¹Ԥˤ�äƥ���ϥ󥹤���
    public
    def enhance( &block )
      if block_given?
        @actions << block 
      end
      return register
    end
    
    # �ǥХå���
    public
    def inspect
      return %{#<Deft::Template: @name="#{@name}">}
    end
  end
end
  
### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
