#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'

require 'lucie/template'
require 'lucie/time-stamp'

module Lucie
  
  update(%q$LastChangedDate$)
  
  class BooleanTemplate < Template
    # BooleanTemplate をあらわす String オブジェクトを返します
    public
    def to_s
      template_string =  "Template: #{name}\n"
      template_string += "Type: boolean\n"
      if description
        template_string += "Description: #{short_description}\n"
        template_string += long_description + "\n"
      end
        
      if description_ja
        template_string += "Description-ja: #{short_description_ja}\n" 
        template_string += long_description_ja
      end
    end
    
    #--
    # FIXME : Lucie::Template クラスへ移動
    #++
    private
    def long_description
      return format_long_description( description )
    end
    
    #--
    # FIXME : Lucie::Template クラスへ移動
    #++
    private 
    def long_description_ja
      return format_long_description( description_ja )
    end
    
    #--
    # FIXME : Lucie::Template クラスへ移動
    #++
    private
    def short_description_ja
      description_ja.split("\n")[0]
    end
    
    #--
    # FIXME : Lucie::Template クラスへ移動
    #++
    private
    def short_description
      description.split("\n")[0]
    end
    
    #--
    # FIXME : Lucie::Template クラスへ移動
    #++
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
