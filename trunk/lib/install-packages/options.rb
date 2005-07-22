#
# $Id: install-packages.rb 772 2005-07-22 09:02:39Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 772 $
# License::  GPL2

module InstallPackages
  # コマンドラインオプションを管理するクラス
  class Options
    PROGRAM_NAME   = 'install_packages'.freeze
    VERSION        = '0.0.1'.freeze
    VERSION_STRING = [PROGRAM_NAME, VERSION].join(' ')
    # サポートされているコマンドラインオプション
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
    
    # あたらしいオブジェクトを返す。シングルトンであることに注意。
    public
    def initialize
      register_options
      set_default_options
    end

    # コマンドラインオプションをパーズする。
    # 設定されたオプションはインスタンス変数としてアクセスできる。
    #
    # Example:
    #  % command --foo='barbaz'
    #  Options.instance.parse( ARGV ).foo 
    #   => 'barbaz'
    # 
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
