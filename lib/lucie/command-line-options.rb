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
  class CommandLineOptions
    include Singleton
    
    # トレースオプションの ON/OFF
    attr :trace
    # ドライランオプションの ON/OFF
    attr :dryrun
    # デバッグオプションの ON/OFF
    attr :debug 
    # ヘルプの表示
    attr :help 
    # セットアップするインストーラ名
    attr :installer_name
    # リソースの表示オプション
    attr :list_resource 
    # フロッピー作成オプション
    attr :make_floppy 
    # verification のスキップの ON/OFF
    attr :skip_verification
    # UI のタイプ
    attr :ui_type 
    # バージョン表示オプション
    attr :version
    
    ###################################################################
    # 設定可能なコマンドラインオプションを管理するモジュール
    #
    module OptionList
      OPTION_LIST = [
      [ "--trace",             "-t",   nil, \
          "Turn on invoke/execute tracing, enable full backtrace." ],
      [ "--dryrun",            "-n",   nil, \
          "Do a dry run without executing actions." ],
      [ "--ui-type",           "-u",   "`console' or `gtk'", \
          "Set user interface type." ],
      [ "--make-floppy",       "-f",   nil, \
          "Make a Lucie boot floppy." ],
      [ "--installer-name",    "-i",   "installer name", \
          "Specify an installer name to setup." ],
      [ "--skip-verification", "-s",   nil, \
          "Do not verify user configuration." ],
      [ "--list-resource",     "-r",   "resource type", \
          "List up registerd resource objects." ],
      [ "--debug",             "-D",   nil, \
          "Displays lots on internal stuff." ],
      [ "--help",              "-h",   nil, \
          "You're looking at it." ],
      [ "--version",           "-v",   nil, \
          "Display  lucie-setup's version and exit." ],
      ]
      
      # GetoptLong オブジェクトの作成用
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
    
    # 新しい CommandLineOptions オブジェクトを返す
    public
    def initialize
      set_default_options
    end
    
    # コマンドラインオプションをパーズし、オプション値を各インスタンス変数にセットする
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
            @trace = true
          when '--dryrun'
            @dryrun = true
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
    
    # デバッグ用
    #--
    # FIXME: インスタンス変数名が重複しているので OptionList 等で一本化する
    #++
    public
    def inspect
      return "[CommandLineOptions: " +
      ["debug=#{@debug.inspect}", "help=#{@help.inspect}", "installer-name=#{@installer_name.inspect}",
      "list-resource=#{@list_resource.inspect}", "make-floppy=#{@make_floppy.inspect}", 
      "skip-verification=#{@skip_verification.inspect}", "ui-type=#{@ui_type.inspect}", "version=#{@version.inspect}]"].join(', ')
    end
    
    private
    def set_default_options
      @trace = false
      @dryrun = false
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
