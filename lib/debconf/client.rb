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

if ENV["DEBIAN_HAS_FRONTEND"] == nil then
  args = ""
  for arg in ARGV
    args << arg << " "
  end
  stdout_dup = STDOUT.clone
  stdin_dup = STDIN.clone
  ENV["DEBCONF_RUBY_STDOUT"] = "#{stdout_dup.fileno}"
  ENV["DEBCONF_RUBY_STDIN"] = "#{stdin_dup.fileno}"
  exec "/usr/share/debconf/frontend #{$0} #{args}"
end

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

  module ConfModule

    DEBCONF_OUT = STDOUT.clone
    STDOUT.reopen(IO.new(ENV["DEBCONF_RUBY_STDOUT"].to_i, "w"))
    DEBCONF_OUT.sync=true
    
    DEBCONF_IN = STDIN.clone
    STDIN.reopen(IO.new(ENV["DEBCONF_RUBY_STDIN"].to_i, "r"))
    DEBCONF_IN.sync=true

    COMMANDS = [
      "capb", "set", "reset", "title", "input",
      "beginblock", "endblock", "go", "get", "register",
      "unregister", "subst", "previous_module", "fset",
      "fget", "purge", "metaget", "version", "clear"
      ]

    def parse_ret (ret)
      if /(\d+)( (.*))?/ =~ ret then
        case $1
          when "0"
           ret = $3
          when "10".."19"
            raise Debconf::Exception::InvalidParametersException
          when "20".."29"
            raise Debconf::Error::SyntaxError, ret
          when "30".."39"
            ## TODO: needs command specific routines (delegator?)
            nil
          else
            raise Debconf::Exception::UnknownReturnValueException, ret
        end
      else
        raise InternalRubyError
      end
      ret
    end

    COMMANDS.each do |command|
      eval "def #{command} (*args)
              DEBCONF_OUT.print \"#{command.upcase} \"
              for s in args
                DEBCONF_OUT.print s
                DEBCONF_OUT.print ' '
              end
              DEBCONF_OUT.print \"\n\"
              parse_ret(DEBCONF_IN.gets.chomp)
            end"
    end
  end
end
