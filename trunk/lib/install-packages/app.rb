#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'singleton'

module InstallPackages
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
      if $config_file
        do_install( $config_file )
      else
        # XXX: /etc/lucie のパスを Lucie ライブラリから取得
        Dir.glob('/etc/lucie/package/*').each do |each|
          do_install( each )
        end
      end
    end

    private
    def do_install( configFileString )
      read_config( configFileString )
      do_commands
      clean_exit
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
          each.new( @list[each] ).go
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
          each.new( @list[each] ).go
          next
        end

        if( each == Command::Taskinst || each == Command::Taskrm )
          each.new( @list ).go
          next
        end

        # other types
        each.new( @list[each] ).go
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
      return { 'install' => Command::Install, 'aptitude-r' => Command::AptitudeR, 
        'aptitude' => Command::Aptitude, 'clean' => Command::Clean}
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
