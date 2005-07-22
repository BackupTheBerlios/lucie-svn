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

  require 'install-packages/abstract-command'
  require 'install-packages/command/hold'
  require 'install-packages/command/taskrm'

  module Command
    class Taskinst < AbstractCommand
      public
      def commandline
        return @list['taskinst'].map do |each|
          %{#{root_command} tasksel -n install #{each}}
        end
      end
    end

    class Clean < AbstractCommand
      public
      def commandline
        return %{#{root_command} apt-get clean}
      end
    end

    class Aptitude < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return [%{#{root_command} aptitude #{APT_OPTION} install #{short_list}}, 
          %{#{root_command} apt-get clean}]
      end

      # XXX: Install と重複
      private
      def short_list
        return @list['aptitude'][0..MAX_PACKAGE_LIST].join(' ')
      end
    end

    class Install < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return [%{#{root_command} apt-get #{APT_OPTION} --force-yes --fix-missing install #{short_list}},
          %{#{root_command} apt-get clean}]
      end

      private
      def short_list
        return @list['install'][0..MAX_PACKAGE_LIST].join(' ')
      end
    end

    class Remove < AbstractCommand
      public
      def commandline
        package_list = @list['remove'].join(' ')
        return %{#{root_command} apt-get --purge remove #{package_list}}
      end
    end

    class DselectUpgrade < AbstractCommand
      public
      def initialize( listHash )
        super listHash
        if $dry_run
          @list['dselect-upgrade'].each do |each|
            puts( each[:package] + ' ' + each[:action] )
          end
        else
          File.open( tempfile, 'w' ) do |file|
            @list['dselect-upgrade'].each do |each|
              file.puts( each[:package] + ' ' + each[:action] )
            end
          end
        end
      end

      public
      def commandline
        return [%{#{root_command} dpkg --set-selections < #{tempfile}},
          %{#{root_command} apt-get #{APT_OPTION} dselect-upgrade},
          %{rm #{tempfile}}]
      end
      
      # TODO: use better uniq filename
      private
      def tempfile
        return %{/tmp/target/tmp/dpkg-selections.tmp}
      end
    end

    class AptitudeR < AbstractCommand
      public
      def commandline
        package_list = @list['aptitude-r'].join(' ')
        return %{#{root_command} aptitude -r #{APT_OPTION} install #{package_list}}
      end
    end
  end
  
  # install-packages のアプリケーションクラス
  class App
    include Singleton

    #--
    # XXX /tmp/target のパスは Lucie のライブラリから取得
    #++
    private
    def root_command
      return ($LUCIE_ROOT == '/') ? '' : "chroot /tmp/target" 
    end

    # あたらしいオブジェクトを返す。シングルトンであることに注意。
    public
    def initialize
      @list = Hash.new( [] )
      @preload_list = [] 
      @preloadrm_list = [] 
    end

    # install-packages のメインルーチン
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
        clean_exit
      end
    end

    private
    def clean_exit
      # in case of unconfigured packages because of apt errors
      # retry configuration 
      AbstractCommand.execute %{#{root_command} dpkg --configure --pending}
      # check if all went right
      AbstractCommand.execute %{#{root_command} dpkg -C}
      # clean apt cache
      AbstractCommand.execute %{#{root_command} apt-get clean}
    end

    # install, clean 等のコマンドを実際に実行する
    public
    def do_commands
      commands.each do |each|
        if each == Command::Clean
          each.new( @list ).go
          next
        end

        # skip if empty list
        next if @list[each].empty?

        if each == Command::DselectUpgrade
          each.new( @list ).go
          next
        end

        if each == Command::Hold
          each.new( @list ).go
          next
        end

        if( each == Command::Install || each == Command::Aptitude )
          # TODO: 知らないパッケージを libapt-pkg で調べる
          each.new( @list ).go
          next
        end

        if( each == Command::Taskinst || each == Command::Taskrm )
          each.new( @list ).go
          next
        end

        # other types
        each.new( @list ).go
      end
    end

    private
    def commands
      return [Command::Hold, Command::Taskrm, Command::Taskinst,
        Command::Clean, Command::AptitudeR, Command::Aptitude,
        Command::Install, Command::Remove, Command::DselectUpgrade]
    end

    # prerequire で指定されているファイルを取得する
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

    # 設定ファイルを読み込む
    #--
    # TODO: 設定ファイルの書式を Ruby スクリプトにする
    #++
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
        @list[string2command[type]] += each.split
      end
      return @list
    end
    
    private
    def string2command
      return { 'install' => Command::Install }
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
