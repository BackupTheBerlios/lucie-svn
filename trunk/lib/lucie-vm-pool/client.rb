#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module LucieVmPool
  module Exception
    class InvalidParametersException < ::Exception; end
  end
  
  module Error
    class SyntaxError < ::SyntaxError; end
  end
  
  module Client        
    def parse_response( responseString )
      if /(\d+) (.*)/ =~ responseString
        case $1.to_i
        when 0
          responseString = $2
        when 10..19
          raise Exception::InvalidParametersException, responseString
        when 20..29
          raise Error::SyntaxError, responseString
        end
      end
      return responseString
    end
    module_function :parse_response
    
    public
    def get( socket, resourceNameString )
      socket.print( "GET #{resourceNameString}\r\n" )
      return parse_response( socket.gets.chomp )
    end
    module_function :get
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
