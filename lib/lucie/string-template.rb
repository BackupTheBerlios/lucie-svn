#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'

require 'deft/template'
require 'lucie/time-stamp'

module Deft
  
  Lucie.update(%q$LastChangedDate$)
  
  # string タイプの Template をあらわすクラス
  class StringTemplate < Template
    def_delegator :@template, :name
    def_delegator :@template, :default
    def_delegator :@template, :short_description
    def_delegator :@template, :extended_description
    def_delegator :@template, :short_description_ja
    def_delegator :@template, :extended_description_ja    

    # 新しい StringTemplate オブジェクトを返します
    public
    def initialize( aTemplate )
      @template = aTemplate
    end
        
    # StringTemplate をあらわす String オブジェクトを返します
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: string\n"
      template_string += "Default: #{default}\n" if default
      template_string += "Description: #{short_description}\n" if short_description
      template_string += format_extended_description( extended_description ) + "\n" if extended_description
      template_string += "Description-ja: #{short_description_ja}\n" if short_description_ja
      template_string += format_extended_description( extended_description_ja ) if extended_description_ja
      return template_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
