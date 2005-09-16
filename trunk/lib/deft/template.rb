#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/boolean-template'
require 'deft/multiselect-template'
require 'deft/note-template'
require 'deft/password-template'
require 'deft/select-template'
require 'deft/string-template'
require 'deft/text-template'
require 'deft/time-stamp'
require 'forwardable'
require 'lucie/string'

# �ƥ�ץ졼�Ȥ���Ͽ
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft
  update(%q$Id$)

  module Exception
    class UnknownTemplateTypeException < ::Exception; end
  end

  # �ƥ�ץ졼�Ȥδ����ѥ��饹
  #--
  # FIXME: update ���ޥ�ɤǥ����ॹ����פ򹹿�
  #++ 
  class Template
    extend Forwardable
    
    TEMPLATES = {}
    
    attr_reader :name
    def_delegator :@template, :class
    def_delegator :@template, :choices
    def_delegator :@template, :choices=
    def_delegator :@template, :default
    def_delegator :@template, :default= 
    def_delegator :@template, :extended_description 
    def_delegator :@template, :extended_description=
    def_delegator :@template, :extended_description_ja        
    def_delegator :@template, :extended_description_ja=
    def_delegator :@template, :short_description    
    def_delegator :@template, :short_description=
    def_delegator :@template, :short_description_ja
    def_delegator :@template, :short_description_ja=
    
    # Template ����Ͽ����Ƥ���Ф�����֤�
    # ��Ͽ����Ƥ��ʤ���� nil ���֤�
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template ����Ͽ����Ƥ���Ф�����֤�
    # ��Ͽ����Ƥ��ʤ���� nil ���֤�
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end

    # �ƥ�ץ졼�Ȥ���Ͽ
    private
    def register
      @actions.each { |each| result = each.call( self ) }
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

    # �ƥ�ץ졼�Ȥη������ꤹ��
    public
    def template_type=( templateTypeString )
      if template_table[templateTypeString].nil?
        raise Exception::UnknownTemplateTypeException, templateTypeString
      end
      @template = template_table[templateTypeString].new( @name )
      TEMPLATES[@name] = @template
    end

    # �ƥ�ץ졼��̾ => �������饹�Υơ��֥�
    private
    def template_table
      return AbstractTemplate.template2class_table.invert
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
