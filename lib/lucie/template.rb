#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'forwardable'
require 'lucie/string'
require 'lucie/time-stamp'

# 新しいテンプレートを登録します
def template( nameString, &block )
  Lucie::Template.define_template nameString, &block
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
  # TODO: Description の空行に勝手に '.' をつけてくれるようにする
  # TODO: substによる動的テンプレート生成 (debconf spec を参照) をサポート
  #++
  class Template
    extend Forwardable
    
    attr :name
    def_delegator :@hash, :[]
    def_delegator :@hash, :size
    
    TEMPLATES = {}
    BOOLEAN = 'BOOLEAN'.freeze
    STRING = 'STRING'.freeze
    NOTE = 'NOTE'.freeze
    SELECT = 'SELECT'.freeze
    MULTISELECT = 'MULTISELECT'.freeze
    
    # Template が定義されていれば定義されているテンプレート、そうでなければ nil を返します
    public
    def self.template_defined?( templateName )
      TEMPLATES[templateName]
    end

    # Template を登録します
    public
    def register
      puts "Template #{@name} を登録" if $trace
      @actions.each { |each| result = each.call( self ) }
      return self
    end
    
    # Template をあらわす String オブジェクトを返します
    #--
    # FIXME : Multiselect < Template などのサブクラス化
    #++
    public
    def to_s
      template_string = "Template: #{name}\n" + "Type: #{template_type}\n"
      template_string += "Choices: #{choices}\n" if choices
      
      if description
        short_description = description.split("\n")[0]
        template_string += "Description: #{short_description}\n"
        template_string += description.split("\n")[1..-1].map do |each|
          case each
          when /\A\S*\Z/
          ' .'
          else
          ' ' + each
          end
        end.join("\n")
        template_string += "\n"
      end
      
      if description_ja
        short_description_ja = description_ja.split("\n")[0]
        template_string += "Description-ja: #{short_description_ja}\n" 
        template_string += description_ja.split("\n")[1..-1].map do |each|
          case each
          when /\A\s*\Z/
          ' .'
          else
          ' ' + each
          end
        end.join("\n")
        template_string += "\n"
      end
    end
    
    # 現在登録されている Template をクリアします
    public
    def self.clear
      TEMPLATES.clear
    end
    
    private
    def self.define_template( nameString, &block )
      template = lookup( nameString )
      return template.enhance( &block )
    end
    
    # Template を lookup し、もしすでに同名の Template が存在すればそれを返します。
    # 存在しない場合、新たに登録します。
    public
    def self.lookup( nameString )
      return TEMPLATES[nameString] ||= self.new( nameString )
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
      return self
    end
    
    # テンプレートの 'Type:' を指定します
    public
    def template_type=( typeString )
      @hash['Type'] = typeString
    end
    
    # テンプレートの 'Type:' を返します
    public
    def template_type
      return @hash['Type']
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
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
