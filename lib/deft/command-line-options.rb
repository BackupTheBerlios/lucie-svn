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

update(%q$Date$)

module Deft
  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  class CommandLineOptions
    include Singleton
    
    attr :help 
    attr :ruby_code
    attr :template
    attr :trace 
    attr :version
    attr :question

    module OptionList
      OPTION_LIST = [
      [ '--ruby-code',  '-r',   'question name', \
          'show concrete state definition in Ruby code.' ],
      [ '--trace',          '-T',   nil, \
          'displays lots on internal stuff.' ],
      [ '--help',           '-h',   nil, \
          "you're looking at it." ],
      [ '--version',        '-v',   nil, \
          "display  lucie-setup's version and exit." ],
      [ '--template',        '-t',   nil, \
          'show all the registered templates and exit.' ],
      [ '--question',        '-q',   nil, \
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
          when '--question'
            @question = true
          when '--template'
            @template = true
          when '--ruby-code'
            @ruby_code = argument
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
       "version=#{@version.inspect}", "ruby-code=#{@ruby_code.inspect}",
       "template=#{@template.inspect}", "question=#{@question.inspect}"].join(', ') + ']'
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
