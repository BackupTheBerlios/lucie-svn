# = commandline option handling classes and modules.
#
# $Id: command-line-options.rb 14 2005-01-19 06:32:24Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 1.13 $
# License::  GPL2

require 'English'
require 'getoptlong'
require 'lucie/time-stamp'
require 'singleton'

module Lucie

  update(%q$Date: 2005-01-19 15:32:24 +0900 (Wed, 19 Jan 2005) $)

  ####################################################################
  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  # 
  class CommandLineOptions
    include Singleton
    
    attr :debug 
    attr :help 
    attr :installer_name
    attr :list_resource 
    attr :make_floppy 
    attr :skip_verification
    attr :ui_type 
    attr :version

    module OptionList
      OPTION_LIST = [
        [ "--ui-type",        "-u",  "`console' or `gtk'", \
          "set user interface type." ],
        [ "--make-floppy",    "-f",  nil, \
          "make a Lucie boot floppy." ],
        [ "--installer-name", "-i",  "installer name", \
          "specify an installer name to setup." ],
        [ "--skip-verification", "-s",  nil, \
          "do not verify user configuration." ],
        [ "--list-resource",  "-r",   "resource type", \
          "list up registerd resource objects." ],
        [ "--debug",          "-D",   nil, \
          "displays lots on internal stuff." ],
        [ "--help",           "-h",   nil, \
          "you're looking at it." ],
        [ "--version",        "-v",   nil, \
          "display  lucie-setup's version and exit." ],
      ]

      public
      def self.options
        OPTION_LIST.map do |long, short, arg,|
          [long, 
           short, 
           arg ? GetoptLong::REQUIRED_ARGUMENT : GetoptLong::NO_ARGUMENT 
          ]
        end
      end
    end
    
    public
    def initialize
      set_default_options
    end

    # Parse the command line options.
    public
    def parse( argvArray )
      old_argv = ARGV.dup
      begin
        ARGV.replace argvArray

        getopt_long = GetoptLong.new( *OptionList.options )
        getopt_long.quiet = true

        getopt_long.each do |option, argument|
          case option
          when '--make-floppy'
            @make_floppy = true
          when '--ui-type'
            @ui_type = argument.intern
          when "--skip-verification"
            @skip_verification = true
          when "--list-resource"
            @list_resource = argument.intern
          when "--installer-name"
            @installer_name = argument.intern
          when "--debug"
            @debug = true
          when "--help"
            @help = true
          when "--version"
            @version = true
          end
        end
      ensure
        ARGV.replace old_argv
      end
    end

    public
    def inspect
      return "[CommandLineOptions: " +
      ["debug=#{@debug.inspect}", "help=#{@help.inspect}", "installer-name=#{@installer_name.inspect}",
      "list-resource=#{@list_resource.inspect}", "make-floppy=#{@make_floppy.inspect}", 
      "skip-verification=#{@skip_verification.inspect}", "ui-type=#{@ui_type.inspect}", "version=#{@version.inspect}]"].join(', ')
    end
    
    private
    def set_default_options
      @debug = false
      @help = false
      @installer_name = nil
      @list_resource = nil
      @make_floppy = false
      @skip_verification = false
      @ui_type = :console
      @version = false
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
