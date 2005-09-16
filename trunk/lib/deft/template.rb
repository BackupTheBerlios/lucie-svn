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

# テンプレートを登録
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft
  update(%q$Id$)

  module Exception
    class UnknownTemplateTypeException < ::Exception; end
  end

  # テンプレートの管理用クラス
  #--
  # FIXME: update コマンドでタイムスタンプを更新
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
    
    # Template が登録されていればそれを返す
    # 登録されていなければ nil を返す
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template が登録されていればそれを返す
    # 登録されていなければ nil を返す
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end

    # テンプレートを登録
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
    
    # 登録されている Template の配列を返す
    public
    def self.templates
      return TEMPLATES.values
    end
    
    # 登録されている Template をクリアする
    public
    def self.clear
      TEMPLATES.clear
    end
    
    # テンプレートを定義する
    private
    def self.define_template( nameString, &block )
      template = lookup( nameString )      
      return template.enhance( &block )
    end
    
    # 登録されている Template を名前で探す.
    # もし登録されている物が無ければ new する
    public
    def self.lookup( nameString )
      return TEMPLATES[nameString] ||= self.new( nameString )
    end

    # テンプレートの型を設定する
    public
    def template_type=( templateTypeString )
      if template_table[templateTypeString].nil?
        raise Exception::UnknownTemplateTypeException, templateTypeString
      end
      @template = template_table[templateTypeString].new( @name )
      TEMPLATES[@name] = @template
    end

    # テンプレート名 => 実装クラスのテーブル
    private
    def template_table
      return AbstractTemplate.template2class_table.invert
    end
    
    # 新しい Template オブジェクトを返す
    #--
    # TODO: nameString の型や書式をチェック (?)
    #++
    public
    def initialize( nameString )
      @actions = []
      @name = nameString
    end
    
    # Template の属性をブロック実行によってエンハンスする
    public
    def enhance( &block )
      if block_given?
        @actions << block 
      end
      return register
    end
    
    # デバッグ用
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
