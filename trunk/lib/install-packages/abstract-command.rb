#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  class AbstractCommand
    # 同時にインストールできるパッケージの数
    MAX_PACKAGE_LIST = 99
    # apt のデフォルトオプション
    APT_OPTION = %{-y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"}

    attr_reader :list
    attr_writer :list
    attr_reader :preload
    attr_writer :preload
    attr_reader :preloadrm
    attr_writer :preloadrm
    
    # execute a command or only print it
    #--
    # XXX: --dry_run モードのサポート
    #++
    def self.execute( commandLineString )
      if $dry_run
        $stderr.puts commandLineString 
        return
      end
      rc = system( commandLineString )
      $stderr.puts "ERROR: #{$?.exitstatus}" unless rc
    end

    public
    def initialize( packageList = [] )
      @list = packageList
      @preload = []
      @preloadrm = []
    end

    public
    def go
      case commandline
      when String
        AbstractCommand.execute commandline
      when Array
        commandline.each do |each|
          AbstractCommand.execute each
        end
      end
    end

    private
    def short_list
      case @list
      when Array
        return @list[0..MAX_PACKAGE_LIST].join(' ')
      when String
        return @list
      else
        raise "This shouldn't happen"
      end
    end
    
    #--
    # XXX /tmp/target のパスは Lucie のライブラリから取得
    #++
    private
    def root_command
      return ($LUCIE_ROOT == '/') ? '' : "chroot /tmp/target" 
    end

    private
    def preload_commandline
      return (@preload + @preloadrm).map do |each|
        if URI.regexp('file')=~ each[:url]
          file = URI.parse(each[:url]).path
          %{cp #{File.join('/etc/lucie/', file)} #{File.join('/tmp/target/', each[:directory])}}
        else
          %{wget -nv -P#{File.join('/tmp/target/', each[:directory])} #{each[:url]}}
        end 
      end
    end
    
    private
    def preloadrm_teardown_commandline
      return @preloadrm.map do |each|
        basename = File.basename(URI.parse(each[:url]).path)
        %{rm #{File.join('/tmp/target/', each[:directory], basename)}}
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
