#
# $Id: install-packages.rb 759 2005-07-22 08:20:25Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 759 $
# License::  GPL2

module InstallPackages
  class AbstractCommand
    # 同時にインストールできるパッケージの数
    MAX_PACKAGE_LIST = 99
    # apt のデフォルトオプション
    APT_OPTION = %{-y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"}

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
    def initialize( listHash )
      @list = listHash
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
    
    #--
    # XXX /tmp/target のパスは Lucie のライブラリから取得
    #++
    private
    def root_command
      return ($LUCIE_ROOT == '/') ? '' : "chroot /tmp/target" 
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
