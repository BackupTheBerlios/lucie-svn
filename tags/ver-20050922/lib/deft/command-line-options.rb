#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'English'
require 'deft/time-stamp'
require 'getoptlong'
require 'singleton'

module Deft
  update(%q$Id$)

  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  class CommandLineOptions
    include Singleton
    
    attr_reader :run
    attr_reader :help 
    attr_reader :template
    attr_reader :trace 
    attr_reader :version
    attr_reader :question

    module OptionList # :nodoc:
      OPTION_LIST = [
        [ '--run',            '-R',   'file path', \
          'run debconf.' ],
        [ '--trace',          '-T',   nil, \
          'displays lots on internal stuff.' ],
        [ '--help',           '-h',   nil, \
          "you're looking at it." ],
        [ '--version',        '-v',   nil, \
          "display  lucie-setup's version and exit." ],
        [ '--template',       '-t',   'file path', \
          'show all the registered templates and exit.' ],
        [ '--question',       '-q',   'file path', \
          'show all the registered questions and exit.' ],
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
          when '--run'
            @run = argument
          when '--question'
            @question = argument
          when '--template'
            @template = argument
          when '--trace'
            @trace = true
          when '--help'
            @help = true
          when '--version'
            @version = true
          end
        end
      ensure
        ARGV.replace old_argv
      end
    end

    private
    def set_default_options
      @help = false
      @template = false
      @trace = false
      @version = false
      @question = false
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
