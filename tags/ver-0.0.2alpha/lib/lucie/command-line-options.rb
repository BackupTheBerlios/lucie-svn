# = commandline option handling classes and modules.
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'English'
require 'getoptlong'
require 'lucie/time-stamp'
require 'singleton'

module Lucie

  update(%q$Date$)

  ####################################################################
  # We handle the parsing of options, and subsequently as a singleton
  # object to be queried for option values
  # 
  class CommandLineOptions #:nodoc:
    include Singleton
    
    attr :debug 
    attr :help 
    attr :installer_name
    attr :list_resource 
    attr :version
    attr :config_dir
    attr :installer_base_dir
    attr :nfsroot_dir
    attr :verbose

    module OptionList # :nodoc:
      OPTION_LIST = [
        [ "--installer-name",     "-i",  "installer name", \
          "specify an installer name to setup." ],
        [ "--list-resource",      "-r",   "resource type", \
          "list up registerd resource objects." ],
        [ "--debug",              "-D",   nil, \
          "displays lots on internal stuff." ],
        [ "--help",               "-h",   nil, \
          "you're looking at it." ],
        [ "--version",            "-V",   nil, \
          "display  lucie-setup's version and exit." ],
        [ "--config-dir",         "-c",   "directory path", \
          "specify configuration directory path." ],
        [ "--installer-base-dir", "-b",   "directory path", \
          "specify installer base directory path." ],
        [ "--nfsroot-dir",        "-n",   "directory path", \
          "specify nfsroot directory path." ],
        [ "--verbose",            "-v",   nil, \
          "be verbose." ],         
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
          when "--list-resource"
            @list_resource = argument
          when "--installer-name"
            @installer_name = argument
          when "--debug"
            @debug = true
          when "--help"
            @help = true
          when "--version"
            @version = true
          when '--config-dir'
            @config_dir = argument
          when '--installer-base-dir'
            @installer_base_dir = argument
          when '--nfsroot-dir'
            @nfsroot_dir = argument
          when '--verbose'
            @verbose = true
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
      "list-resource=#{@list_resource.inspect}", "version=#{@version.inspect}]"].join(', ')
    end
    
    private
    def set_default_options
      @debug = false
      @help = false
      @installer_name = nil
      @list_resource = nil
      @version = false
      @config_dir = '/etc/lucie/'
      @installer_base_dir = '/var/lib/lucie/installer_base'
      @nfsroot_dir = '/var/lib/lucie/nfsroot'
      @verbose = false
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
