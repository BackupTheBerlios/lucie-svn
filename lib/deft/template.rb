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
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft
  
  Lucie.update(%q$LastChangedDate$)
  
  # Debconf �p templates �t�@�C���𐶐����� Template ���`���܂��B
  #
  # Example:
  #
  #   template( 'lucie/overview' ) do |template|
  #     template.type = TextTemplate
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
  #
  #--
  # TODO: subst�ɂ�铮�I�e���v���[�g���� (debconf spec ���Q��) ���T�|�[�g
  #++
  class Template
    extend Forwardable
    
    attr :name
    attr_accessor :default
    attr_accessor :choices
    attr_accessor :short_description
    attr_accessor :extended_description
    attr_accessor :short_description_ja
    attr_accessor :extended_description_ja
    attr_accessor :template_type    
    
    def_delegator :@variable, :[]
    def_delegator :@variable, :size
    
    TEMPLATES = {}
    
    # �e���v���[�g�𖼑O�ŒT���܂��B������Ȃ��ꍇ�ɂ� nil ��Ԃ��܂�
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
      puts "Template #{@name} (#{@template_type}) ��o�^" if $trace
      @actions.each { |each| result = each.call( self ) }
      if @template_type
        _template = @template_type.new( self )
        _template.template_type = @template_type
        _template.default = @default
        _template.choices = @choices
        _template.short_description = @short_description
        _template.extended_description = @extended_description
        _template.short_description_ja = @short_description_ja
        _template.extended_description_ja = @extended_description_ja        
        TEMPLATES[@name] = _template      
        return _template
      else
        return self
      end
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
    def self.define_template( nameString, &block )
      template = lookup( nameString )      
      return template.enhance( &block )
    end
    
    # Template �� lookup ���A�������łɓ����� Template �����݂���΂����Ԃ��܂��B
    # ���݂��Ȃ��ꍇ�A�V���ɓo�^���܂��B
    public
    def self.lookup( nameString )
      return TEMPLATES[nameString] ||= self.new( nameString )
    end
    
    # �����炵�� Template �I�u�W�F�N�g��Ԃ�
    public
    def initialize( nameString )
      @actions = []
      @name = nameString
      @variable = {}
    end
    
    # �e���v���[�g���u���b�N��p���ăG���n���X���܂��Bself ��Ԃ��܂��B
    public
    def enhance( &block )
      @actions << block if block_given?
      return register
    end
                  
    private
    def format_extended_description( descriptionString )
      return descriptionString.unindent_auto.split("\n").map do |each|
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
