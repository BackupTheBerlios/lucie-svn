#!/usr/bin/env ruby
#
# $Id: lucie-setup,v 1.24 2004/07/27 05:07:02 takamiya Exp $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 1.24 $
# License::  GPL2

require 'English'
require 'lucie/command-line-options'
require 'lucie/time-stamp'
require 'singleton'

module Lucie

  update(%q$Date: 2004/07/27 05:07:02 $) 
  
  ##############################################################################
  # Lucie main application object.  When invoking +lucie-setup+ from the command
  # line, a Setup object is created and run.
  #
  class Setup # :nodoc:
    include Singleton
    
    LUCIE_VERSION = '0.0.1'
    VERSION_STRING = ['lucie-setup', LUCIE_VERSION, '('+Lucie::svn_date+')'].join(' ')
    
    public
    def main
      do_option
    end

    private
    def do_option
      @commandline_options = CommandLineOptions.instance
      @commandline_options.parse ARGV.dup
      if @commandline_options.help
        help
        exit
      end
      if @commandline_options.version
        puts VERSION_STRING
        exit
      end
      exit(0) if @commandline_options.list_resource
    end
    
    private
    def usage
      puts "Usage: lucie-setup {options}"
    end
    
    private
    def help
      puts VERSION_STRING
      puts
      usage
      puts
      puts "Options:"
      CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
        opt = sprintf("%25s", "#{long}, #{short}")
        oparg = sprintf("%-7s", arg)
        print "#{opt} #{oparg}"
        desc = desc.split("\n")
        if arg.nil? || arg.length < 7
          puts desc.shift
        else
          puts
        end
        desc.each do |line|
          puts(' '*33 + line)
        end
        puts
      end
    end
  end 
end

########
# Main #
########

if __FILE__ == $PROGRAM_NAME
  Lucie::Setup.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
