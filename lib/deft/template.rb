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

# 新しいテンプレートを登録します
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft
  module Exception
    class UnknownTemplateTypeException < ::Exception; end
    class InvalidAttributeException < ::Exception; end
  end
     
  # Debconf 用 templates ファイルを生成する Template を定義する。
  #
  # Example:
  #
  #   require 'deft/template'
  #
  #   include Deft
  #   template( 'lucie/overview' ) do |template|
  #     template.type = 'text'
  #     template.description_ja = (<<-DESCRIPTION)
  #     この Lucie 設定パッケージは、以下のパッケージをインストール・設定するような
  #     Lucie の設定を生成します。
  # 
  #     設定されるパッケージのリストは以下の通りです。
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
    
    # テンプレートを名前で探す。見つからない場合には nil を返す。
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template が定義されていれば定義されているテンプレート、そうでなければ nil を返す。
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end
    
    private
    def register
      @actions.each { |each| result = each.call( self ) }
      puts "Template #{@name} (#{@template_type}) を登録" if $trace
      if @template     
        TEMPLATES[@name] = @template      
        return @template
      else
        return self
      end
    end
    
    # 登録されているテンプレートのリストを返す
    public
    def self.templates
      return TEMPLATES.values
    end
    
    # 現在登録されている Template をクリアする
    public
    def self.clear
      TEMPLATES.clear
    end
    
    private
    def self.define_template( nameString, &block )
      template = lookup( nameString )      
      return template.enhance( &block )
    end
    
    # Template を lookup し、もしすでに同名の Template が存在すればそれを返す。
    # 存在しない場合、新たに登録する。
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
    
    # あたらしい Template オブジェクトを返す
    public
    def initialize( nameString )
      @actions = []
      @name = nameString
    end
    
    # テンプレートをブロックを用いてエンハンスする。self を返す。
    public
    def enhance( &block )
      @actions << block if block_given?
      return register
    end
    
    # デバッグ用
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
