#
# $Id: state.rb 49 2005-02-07 04:30:20Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 49 $
# License::  GPL2

require 'forwardable'
require 'lucie/time-stamp'

module Lucie
  
  update(%q$Date: 2005-02-07 13:30:20 +0900 (Mon, 07 Feb 2005) $)
  
  # Debconf ‚Ì Template ‚ð•\Œ»‚·‚éƒNƒ‰ƒX
  class Template
    extend Forwardable
    
    def_delegator :@hash, :[]
    def_delegator :@hash, :size
    
    def initialize( templateString )
      @hash = {}
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
        @hash[template_name] = template_hash
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
