#
## Debconf Client Driver for Ruby
#
#  Copyright (C) 1999  Masato Taruishi <taru@debian.org>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License with
#  the Debian GNU/Linux distribution in file /usr/share/common-licenses/GPL;
#  if not, write to the Free Software Foundation, Inc., 59 Temple Place,
#  Suite 330, Boston, MA  02111-1307  USA

module Debconf

  ## TODO: need to implement Exception & Error using exception
  module Exception
    class InvalidParametersException < ::Exception; end
    class UnknownReturnValueException < ::Exception; end
  end

  module Error
    class SyntaxError < ::SyntaxError; end
    class InternalError < ::RuntimeError; end
    class InternalRubyError < ::RuntimeError; end
  end

  module Client
    COMMANDS = [
      "capb", "set", "reset", "title", "input",
      "beginblock", "endblock", "go", "get", "register",
      "unregister", "subst", "previous_module", "fset",
      "fget", "purge", "metaget", "version", "clear"
    ]
    
    # Debconf からのレスポンスをパーズする
    def parse_response( responseString )
      if /(\d+)( (.*))?/ =~ responseString
        case $1.to_i
        when 0
          responseString = $3
        when 10..19
          raise Exception::InvalidParametersException
        when 20..29
          raise Error::SyntaxError, responseString
        when 30..99
          ## TODO: needs command specific routines (delegator?)
          return $1.to_i
        when 100..109
          raise Error::InternalError
        else
          raise Exception::UnknownReturnValueException, responseString
        end
      else
        raise Error::InternalRubyError
      end
      return responseString
    end
    module_function :parse_response

    STDOUT.sync = true
    STDIN.sync  = true
  
    COMMANDS.each do |command|
      eval %-
        def #{command}( *args )
          stdout = $stdout_mock ? $stdout_mock : STDOUT
          stdin  = $stdin_mock  ? $stdin_mock  : STDIN          
          stdout.print(("#{command.upcase} " + args.join(' ')).rstrip + "\n")
          parse_response stdin.gets.chomp
        end
        module_function :#{command}
      -
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:

