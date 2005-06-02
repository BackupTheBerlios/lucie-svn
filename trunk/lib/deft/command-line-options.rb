#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'English'
require 'getoptlong'
require 'time-stamp'
require 'singleton'

update(%q$Id$)

module Deft
  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  class CommandLineOptions
    include Singleton
    
    attr_reader :build
    attr_reader :run
    attr_reader :help 
    attr_reader :template
    attr_reader :trace 
    attr_reader :version
    attr_reader :question

    module OptionList
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
      [ '--build',          '-b',   'file path', \
          'build lmp using template/question definition file.'],
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
          when '--build'
            @build = argument
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

    public
    def inspect
      return '[CommandLineOptions: ' +
        ["trace=#{@trace.inspect}", "help=#{@help.inspect}",
        "version=#{@version.inspect}", "template=#{@template.inspect}", 
        "question=#{@question.inspect}", "run=#{@run.inspect}", "build=#{@build.inspect}"].join(', ') + ']'
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
