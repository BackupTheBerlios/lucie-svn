#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'English'
require 'getoptlong'
require 'singleton'

module LMP
  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  class CommandLineOptions
    include Singleton
    
    attr_reader :conflict_with
    attr_reader :depend_to
    attr_reader :help 
    attr_reader :package_list
    attr_reader :version

    module OptionList
      OPTION_LIST = [
        [ '--trace',          '-t',   nil, \
          "use the debug trace mode."],
        [ '--help',           '-h',   nil, \
          "you're looking at it." ],
        [ '--version',        '-v',   nil, \
          "display lucie-setup's version and exit." ],
        [ '--package-list',   '-p',   '[PACKAGE LIST]', \
          "specify LMP package list file path." ],
        [ '--depend-to?',     '-d',   '[OTHER PACKAGE LIST]', \
          "display if this package depends to other package." ],
        [ '--conflict-with?',  '-c',  '[OTHER PACKAGE LIST]', \
          "display if this package conflicts with other package." ],
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
          when '--trace'
            $trace = true
          when '--depend-to?'
            @depend_to = argument
          when '--conflict-with?'
            @conflict_with = argument
          when '--package-list'
            @package_list = argument
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
      @version = false
      @conflict_with = nil
      @depend_to = nil
      @package_list = nil
      $trace = false
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
