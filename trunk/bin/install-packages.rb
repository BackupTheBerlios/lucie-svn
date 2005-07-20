#!/usr/bin/ruby1.8
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'singleton'
require 'uri'

module InstallPackages
  class Options
    PROGRAM_NAME   = 'install_packages'.freeze
    VERSION        = '0.0.1'.freeze
    VERSION_STRING = [PROGRAM_NAME, VERSION].join(' ')

    OPTIONS = { '--debug' => { :long_option => "--debug",
                               :short_option => "-D",
                               :argument => nil,
                               :description => "displays lots on internal stuff." ,
                               :default => nil,
                               :proc => Proc.new do |argument| $trace = true end },
                 '--help' => { :long_option => "--help",
                               :short_option => "-h",
                               :argument => nil,
                               :description => "you're looking at it.",
                               :default => nil,
                               :proc => Proc.new do |argument| OptionList.usage end },
              '--version' => { :long_option => "--version",
                               :short_option => "-v",
                               :argument => nil,
                               :description => "display #{PROGRAM_NAME}'s version and exit.",
                               :default => nil,
                               :proc => Proc.new do |argument| puts VERSION_STRING end },
    }

    require 'getoptlong'
    require 'singleton'
    
    include Singleton
    
    OPTIONS.keys.each do |each|
      eval('attr_accessor :' + each.sub(/^--/, '').tr('-', '_'))
    end
    
    module OptionList  #:nodoc:
      @@option_list = []
      
      private
      def OptionList.register_options( long, short, arg, desc )
        @@option_list.push [long, short, arg, desc]
      end
      
      private
      def OptionList.registered_options
        @@option_list.collect do |long, short, arg, desc|
          eval ":#{long[2..-1].tr('-', '_')}"
        end
      end
      
      private
      def OptionList.options
        @@option_list.collect do |long, short, arg,|
          [ long, 
            short, 
            arg ? GetoptLong::REQUIRED_ARGUMENT : GetoptLong::NO_ARGUMENT 
          ]
        end
      end
      
      private
      def OptionList.error( messageString )
        STDERR.puts
        STDERR.puts messageString
        STDERR.puts "\n" << "For help on options, try '#{PROGRAM_NAME} --help'" << "\n\n"
      end
      
      private
      def OptionList.option_desc_tab
        @@option_list.collect do |long, short, arg, desc|
          if arg
            long.size + arg.size 
          else
            long.size
          end
        end.sort.reverse[0] + 10
      end
      
      private
      def OptionList.usage
        puts
        puts VERSION_STRING
        puts
        puts "Options:"
        @@option_list.each do |long, short, arg, desc|
          print( if arg 
                   sprintf("  %-#{option_desc_tab}s", "#{short}, #{long}=#{arg}")
                 else 
                   sprintf("  %-#{option_desc_tab}s", "#{short}, #{long} ")
                 end )
          desc = desc.split("\n")
          puts desc.shift
          desc.each do |each| puts(' '*(option_desc_tab+2) + each) end
        end
        puts
      end
    end
    
    public
    def initialize
      register_options
      set_default_options
    end

    # Parse command line options.
    public
    def parse( argvArray )
      set_default_options
      old_argv = ARGV.dup
      begin
        ARGV.replace argvArray
        getopt_long = GetoptLong.new( *OptionList.options )
        getopt_long.quiet = true
        getopt_long.each do |option, argument|
          if OPTIONS[option]
            self.__send__( eval(':' + option.sub(/^--/, '').tr('-', '_') + '='),
                           (argument!='' ? argument : true) )
            OPTIONS[option][:proc].call( argument ) if OPTIONS[option][:proc]
          end
        end
      rescue GetoptLong::InvalidOption, GetoptLong::MissingArgument => error
        OptionList.error error.message
        raise error
      ensure
        ARGV.replace old_argv
      end
      return self
    end

    public
    def inspect
      OptionList.registered_options.map do |each|
        "#{each} = #{self.send(each)}"
      end.join("\n")
    end

    private
    def register_options
      OPTIONS.values.each do |each|
        OptionList.register_options( each[:long_option], each[:short_option],
                                     each[:argument], each[:description] )
      end
    end

    private
    def set_default_options
      OPTIONS.keys.each do |each|
        self.__send__( eval(':' + each.sub(/^--/, '').tr('-', '_') + '='), 
                       OPTIONS[each][:default] )
      end
    end
  end

  class App
    include Singleton

    MAX_PACKAGE_LIST = 99
    APT_OPTION = %{-y -o Dpkg::Optios::="--force-confdef" -o Dpkg::Options::="--force-confold"}
    # XXX /tmp/target のパスは Lucie のライブラリから取得
    ROOT_COMMAND = ($LUCIE_ROOT == '/') ? '' : "chroot /tmp/target" 

    public
    def initialize
      @list = Hash.new( [] )
      @preload_list = [] 
      @preloadrm_list = [] 
    end

    public
    def main
      begin
        @options = Options.instance.parse( ARGV )
        exit 0 if (@options.version or @options.help)
      rescue GetoptLong::InvalidOption, GetoptLong::MissingArgument
        exit 1
      end
      Dir.glob('/etc/lucie/package/*').each do |each|
        read_config( each )
        do_commands
      end
    end

    public
    def do_commands
      commands.each do |each|
        if each == 'clean'
          execute( "#{ROOT_COMMAND} #{command['clean']}" )
          next
        end

        # skip if empty list
        next if @list[each].empty?

        if each == 'dselect-upgrade'
          dselect_upgrade
          next
        end

        # TODO: hold

        if( each == 'install' || each == 'aptitude' )
          # TODO: 知らないパッケージを libapt-pkg で調べる
          shortlist = @list[each][0..MAX_PACKAGE_LIST].join(' ')
          execute( "#{ROOT_COMMAND} #{command[each]} #{shortlist}" ) if shortlist
          execute( "#{ROOT_COMMAND} #{command['clean']}" ) # XXX do not execute always
          next
        end

        # TODO: tasklist, taskrm

        # other types
        package_list = @list[each].join(' ')
        execute( "#{ROOT_COMMAND} #{command[each]} #{package_list}" ) if package_list
      end
    end

    private
    def command
      return { 'clean'   => 'apt-get clean',
               'install' => "apt-get #{APT_OPTION} --force-yes --fix-missing install" }
    end

    private
    def commands
      %w(hold taskrm taskinst clean aptitude install remove dselect-upgrade)
    end

    # execute a command or only print it
    private
    def execute( commandLineString )
      if $dry_run
        $stderr.puts commandLineString 
        return
      end
      rc = system( commandLineString )
      $stderr.puts "ERROR: #{$?.exitstatus}" unless rc
    end

    public
    def fetch_prerequires
      # FIXME: '/' が 2 個連続するのを修正 (File.join を使う) 
      (@preload_list + @preloadrm_list).each do |each|
        if URI.regexp(%w(file))=~ each[:url]
          file = URI.parse(each[:url]).path
          execute( "cp /etc/lucie/#{file} /etc/lucie/#{each[:directory]}" )
        else
          execute( "wget -nv -P/etc/lucie/#{each[:directory]} #{each[:url]}" )
        end
      end
    end

    public
    def read_config( configPathString )
      @list.clear
      type = nil
      File.open( configPathString, 'r' ).each_line do |each|
        next if /^#/=~ each      # skip comments
        each.gsub!( /#.*$/, '' ) # delete comments
        next if /^\s*$/=~ each   # skip empty lines
        each.chomp!
        if /^PRELOAD\s+(\S+)\s+(\S+)/=~ each
          @preload_list.push( { :url => $1, :directory => $2} )
          next
        end
        if /^PRELOADRM\s+(\S+)\s+(\S+)/=~ each
          @preloadrm_list.push( { :url => $1, :directory => $2} )
          next
        end
        if /^PACKAGES\s+(\S+)\s*/=~ each
          type = $1
          cllist = $POSTMATCH
          next
        end
        unless type
          $stderr.puts "PACKAGES .. line missing in #{configPathString}"
          next
        end
        @list[type] += each.split
      end
      return @list
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  InstallPackages::App.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
