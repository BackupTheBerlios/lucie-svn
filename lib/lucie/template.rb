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

# 新しいテンプレートを登録します
def template( nameString, templateType, &block )
  return Lucie::Template.define_template( nameString, templateType, &block )
end

module Lucie
  
  update(%q$LastChangedDate$)
  
  # Debconf 用 templates ファイルを生成する Template を定義します。
  #
  # Example:
  #
  #   template( 'lucie/overview' ) do |template|
  #     template.type = Text
  #     template.description = (<<-DESCRIPTION)
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
    extend Forwardable
    
    attr :name
    def_delegator :@hash, :[]
    def_delegator :@hash, :size
    
    TEMPLATES = {}
    
    public
    def self.[] ( templateNameString )
      return TEMPLATES[templateNameString]
    end
    
    # Template が定義されていれば定義されているテンプレート、そうでなければ nil を返します
    public
    def self.template_defined?( templateName )
      return TEMPLATES[templateName]
    end

    private
    def register
      puts "Template #{@name} を登録" if $trace
      @actions.each { |each| result = each.call( self ) }
      return self
    end
      
    # 登録されているテンプレートのリストを返します
    public
    def self.templates
      return TEMPLATES.values
    end

    # 現在登録されている Template をクリアします
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
    
    # Template を lookup し、もしすでに同名の Template が存在すればそれを返します。
    # 存在しない場合、新たに登録します。
    public
    def self.lookup( nameString, templateType )
      return TEMPLATES[nameString] ||= templateType.new( nameString )
    end
    
    # template 文字列をパースし、Template オブジェクトのハッシュ (キー:テンプレート名) を返します
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
    
    # あたらしい Template オブジェクトを返す
    public
    def initialize( nameString, attributeHash = {} )
      @actions = []
      @name = nameString
      @hash = attributeHash
    end
    
    # テンプレートをブロックを用いてエンハンスします。self を返します。
    public
    def enhance( &block )
      @actions << block if block_given?
      register
      return self
    end
    
    # テンプレートの 'Type:' を返します
    public
    def template_type
      return self.class
    end
    
    # テンプレートの 'Choices:' を指定します
    public
    def choices=( choicesArray )
      @hash['Choices'] = choicesArray.join(', ')
    end
    
    # テンプレートの 'Choices:' を指定します
    public
    def choices
      return @hash['Choices']
    end
    
    # テンプレートの 'Description:' を指定します
    def description=( descriptionString )
      @hash['Description'] = descriptionString.unindent_auto
    end
    
    # テンプレートの 'Description:' を返します
    def description
      return @hash['Description']
    end

    # テンプレートの 'Description-ja:' を指定します
    def description_ja=( descriptionString )
      @hash['Description-ja'] = descriptionString.unindent_auto
    end
    
    # テンプレートの 'Description-ja:' を返します
    def description_ja
      return @hash['Description-ja']
    end
    
    # テンプレートの 'Default:' を指定します
    def default=( defaultString )
      @hash['Default'] = defaultString
    end
    
    # テンプレートの 'Default:' を返します
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
