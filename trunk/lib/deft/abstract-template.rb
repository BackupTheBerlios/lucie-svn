#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'time-stamp'

# FIXME: モジュール/クラス定義の内側へ追いやる
update(%q$Id$)

module Deft
  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

  # すべてのテンプレートクラスの親となるクラス。テンプレートの各アトリ
  # ビュートへのアクセッサメソッド等の共通するメソッドを提供する。テン
  # プレートを追加するといった場合以外にはこのクラスを直接使用すること
  # は無い。
  class AbstractTemplate
    attr_reader :name
    attr_accessor :extended_description_ja
    attr_accessor :extended_description
    attr_accessor :short_description_ja

    # テンプレートクラス名 => テンプレート名のハッシュテーブル
    public
    def self.template2class_table # :nodoc:
      { Deft::TextTemplate => 'text',
        Deft::SelectTemplate => 'select',
        Deft::NoteTemplate => 'note',
        Deft::BooleanTemplate => 'boolean',
        Deft::StringTemplate => 'string',
        Deft::MultiselectTemplate => 'multiselect',
        Deft::PasswordTemplate => 'password' }
    end
    
    public 
    def initialize( nameString ) # :nodoc:
      @name = nameString
    end

    # 選択可能な項目を String の Array で返す。
    #
    #   aTemplate.choices => ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices
      return @choices
    end
    
    # 選択可能な項目を String の Array で指定する。
    #
    #   aTemplate.choices = ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices=( choiceArray )
      unless choiceArray.is_a?( Array )
        raise Exception::InvalidAttributeException, "Choice must be an Array object."
      end
      @choices = choiceArray
    end

    # デフォルト値を String で返す。
    # 
    #   aTemplate.default => "DEFAULT VALUE"
    #
    public
    def default
      return @default
    end

    # デフォルト値を String で指定する。
    # 
    #   aTemplate.default = "DEFAULT VALUE"
    #
    public
    def default=( defaultString )
      unless defaultString.is_a?( String )
        raise Exception::InvalidAttributeException, "Default must be an String."
      end
      @default = defaultString
    end

    # 短いパッケージ説明を String で返す。
    # 
    #   aTemplate.short_description => "Short description about this metapackage"
    #
    public
    def short_description
      return @short_description
    end

    # 短いパッケージ説明を String で指定する。
    # 
    #   aTemplate.short_description = "Short description about this metapackage"
    #
    public
    def short_description=( descriptionString )
      unless descriptionString.is_a?( String )
        raise Exception::InvalidAttributeException, "Description must be an String."
      end
      @short_description = descriptionString
    end

    # デバッグ用
    public
    def inspect # :nodoc:
      return "#<Deft::AbstractTemplate: @name=\"#{@name}\">"
    end
    
    # 文字列に変換する
    public
    def to_s # :nodoc:
      unless ( (@short_description and @extended_description) or
               (@short_description_ja and @extended_description_ja) )
        raise Exception::RequiredAttributeException
      end
    end

    # テンプレート名を String で返す。
    #
    #   aTemplate = Deft::TextTemplate.new( "text template" )
    #   aTemplate.template_type => 'text'
    #
    public
    def template_type
      return AbstractTemplate.template2class_table[self.class]
    end

    private
    def template_string( typeString, *optionalFieldsArray )     
      _template_string =  "Template: #{name}\n"
      _template_string += "Type: #{typeString}\n"
      if optionalFieldsArray.include?( 'choices' ) && choices
        case choices
        when String
          _template_string += "Choices: #{choices}\n" 
        when Array
          _template_string += "Choices: #{choices.join(', ')}\n" 
        else
          raise "This shouldn't happen"
        end
      end
      _template_string += "Default: #{default}\n" if optionalFieldsArray.include?( 'default' ) && default
      _template_string += "Description: #{short_description}\n" if short_description
      _template_string += extended_description.to_rfc822 + "\n" if extended_description
      _template_string += "Description-ja: #{short_description_ja}\n" if short_description_ja
      _template_string += extended_description_ja.to_rfc822 if extended_description_ja
      return _template_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
