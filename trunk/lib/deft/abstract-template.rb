#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'time-stamp'

module Deft
  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

  # すべてのテンプレートの親クラス
  class AbstractTemplate
    attr_reader :name
    attr_accessor :choices
    attr_accessor :extended_description_ja
    attr_accessor :extended_description
    attr_accessor :short_description_ja
    attr_accessor :short_description
    attr_accessor :default

    # テンプレートクラス名 => テンプレート名のハッシュテーブル
    public
    def self.template2class_table
      { Deft::TextTemplate => 'text',
        Deft::SelectTemplate => 'select',
        Deft::NoteTemplate => 'note',
        Deft::BooleanTemplate => 'boolean',
        Deft::StringTemplate => 'string',
        Deft::MultiselectTemplate => 'multiselect',
        Deft::PasswordTemplate => 'password' }
    end
    
    # 新しい AbstractTemplate オブジェクトを返す
    public
    def initialize( nameString )
      @name = nameString
    end
    
    # デバッグ用
    public
    def inspect
      return "#<Deft::AbstractTemplate: @name=\"#{@name}\">"
    end
    
    # 文字列に変換する
    public
    def to_s
      unless ( (@short_description and @extended_description) or
               (@short_description_ja and @extended_description_ja) )
        raise Exception::RequiredAttributeException
      end
    end

    # テンプレート名を返す
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
