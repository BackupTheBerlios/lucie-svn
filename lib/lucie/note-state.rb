#
# $Id: state.rb 49 2005-02-07 04:30:20Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 49 $
# License::  GPL2

require 'lucie/state'
require 'lucie/time-stamp'

#--
# FIXME : 以下の一連のメソッドを String クラスに移動
#++

def minimum_indent( aString )
  indents = aString.map do |line|
    untabify( line.rstrip ).slice(/\A */).length
  end
  (indents - [0]).min || 0
end

def unindent( str, n, tabstop = 8 )
  indent_re = /^ {0,#{n}}/
  str.map do |line|
    if tabstop
      tabify untabify(line, tabstop).sub(indent_re, ''), tabstop
    else
      line.sub indent_re, ''
    end
  end.join('')
end

#--
# NOTE: don't work with UTF-8
#++
def tabify( aString, tabstopNum = 8)
  aString.gsub(/^[ \t]+/) do |sp|
    ntabs, nspaces = untabify(sp, tabstopNum).length.divmod(tabstopNum)
    "\t" * ntabs + ' ' * nspaces
  end
end

#--
# NOTE: don't work with UTF-8
#++
def untabify( aString, tabstopNum = 8)
  aString.gsub(/(.*?)\t/n) do $1 + ' ' * (tabstopNum - ($1.length % tabstopNum)) end
end

def unindent_auto( aString )
  unindent aString, minimum_indent( aString )
end

module Lucie
  
  update(%q$Date: 2005-02-07 13:30:20 +0900 (Mon, 07 Feb 2005) $)
  
  class NoteState < State
    def self.marshal( aQuestion )
      current_state = aQuestion.next || 'nil'
      
      return unindent_auto( <<-CLASS_DEFINITION )
      class #{aQuestion.klass}
        public
        def transit( aDebconfContext )
          aDebconfContext.current_state = #{current_state}
        end
      end
      CLASS_DEFINITION
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
