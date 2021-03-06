#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


module InstallPackages
  class Invoker
    attr_reader :commands


    def initialize
      @commands = []
    end


    def start option = nil
      dry_run = ( option ? option.dry_run : nil )
      @commands.each do | each |
        each.execute dry_run
      end
    end


    def add_command aCommand
      if aCommand.respond_to?( :execute )
        @commands << aCommand
      else
        raise "Invalid command added: #{ aCommand }"
      end
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
