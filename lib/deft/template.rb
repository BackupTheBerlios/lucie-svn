#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'forwardable'
require 'lucie/string'
require 'time-stamp'

update(%q$LastChangedDate$)

# 新しいテンプレートを登録します
def template( nameString, &block )
  return Deft::Template.define_template( nameString, &block )
end

module Deft  
  # Debconf 用 templates ファイルを生成する Template を定義する。
  #
  # Example:
  #
  #   require 'deft/template'
  #
  #   include Deft
  #   template( 'lucie/overview' ) do |template|
  #     template.type = TextTemplate
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
  #
  #--
  # TODO: substによる動的テンプレート生成 (debconf spec を参照) をサポート
  #++
  class Template
    TEMPLATES = {}
    
    attr :name
    attr_accessor :default
    attr_accessor :choices
    attr_accessor :short_description
    attr_accessor :extended_description
    attr_accessor :short_description_ja
    attr_accessor :extended_description_ja
    attr_accessor :template_type        
    
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
      if @template_type
        _template = @template_type.new( self )       
        TEMPLATES[@name] = _template      
        return _template
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
