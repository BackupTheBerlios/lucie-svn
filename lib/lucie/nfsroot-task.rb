#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'
require 'rake/tasklib'

module Rake
  #
  # インストーラの NFSROOT をビルドするタスクを生成する。
  #
  # NfsrootTask は次のターゲットを作成する:
  #
  # [<b><em>nfsroot</em></b>]
  #   Nfsroot タスクのメインタスク
  # [<b><em>:clobber_nfsroot</em></b>]
  #   すべての NFSROOT 関連ファイルを消去する。
  #   このターゲットは自動的にメインの clobber ターゲットに追加される
  #
  # 例:
  #   NfsrootTask.new do |nfsroot|
  #     nfsroot.dir = "tmp"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
  #   end
  #
  # 作成する InstallerBaseTask にはデフォルトの名前以外に自分の好きな名前を
  # つけることもできる。
  #
  #   NfsrootTask.new( :presto_installer ) do |nfsroot|
  #     nfsroot.dir = "tmp"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
  #   end
  #
  #
  #
  class NfsrootTask < TaskLib
    attr_accessor :name
    attr_accessor :dir
    attr_accessor :installer_base
    
    # Nfsroot タスクを作成する。
    public
    def initialize( name=:nfsroot ) # :yield: self
      @name = name
      @dir = '/var/lib/lucie/nfsroot/'
      yield self if block_given?
      @top_dir = File.join( @dir, name.to_s )
      define
    end
    
    private
    def define
      desc "Build the nfsroot filesytem using #{installer_base}"
      task @name
      
      desc "Remove the nfsroot filesystem"
      task paste("clobber_", @name) do
        sh %{umount #{nfsroot( 'dev/pts' )} 1>/dev/null 2>&1} rescue nil
        sh %{rm -rf #{nfsroot( '.??*' )} #{nfsroot( '*' )}} rescue nil
        sh %{find #{@top_dir} ! -type d -xdev -maxdepth 1 | xargs -r rm -f} 
      end
      
      directory @top_dir
      task @name => nfsroot_target
      
      file nfsroot_target => [paste("clobber_", @name), @top_dir] do
        extract_installer_base
        save_all_packages_list
        hoax_some_packages
        upgrade
        add_additional_packages
        copy_lucie_files
        set_timezone
        make_symlinks
      end
    end
    
    # make little changes to nfsroot. because nfsroot is
    # read only for the install clients.
    private 
    def make_symlinks
      rm_rf [nfsroot('etc/mtab'), nfsroot('var/run'), nfsroot('etc/sysconfig')]
      ln_s  '/proc/mounts', nfsroot('etc/mtab')
      ln_s  '/tmp/var/run', nfsroot('var/run')
      ln_sf '/tmp/var/state/discover', nfsroot('var/state/discover')
      ln_sf '/tmp/var/lib/discover', nfsroot('var/lib/discover')
      ln_sf '/tmp/etc/syslogsocket', nfsroot('dev/log')
      ln_sf '/tmp/etc/resolv.conf', nfsroot('etc/resolv.conf')
      ln_sf '/tmp', nfsroot('etc/sysconfig')
      ln_sf '../../sbin/rcS_lucie', nfsroot('etc/init.d/rcS')
      ln_sf '/dev/null', nfsroot('etc/network/ifstate')
      ln_s  '/tmp/binding', nfsroot('var/yp/binding') rescue nil
      rmdir nfsroot('var/log/ksymoops') rescue nil
      ln_s  '/dev/null', nfsroot('var/log/ksymoops')
    end
    
    private
    def nfsroot( filePathName )
      return File.join( @top_dir, filePathName )
    end
    
    private
    def set_timezone
    end
    
    private
    def add_additional_packages
    end
    
    private
    def copy_lucie_files
    end
    
    private
    def extract_installer_base
      sh %{tar -C #{@top_dir} -xzf #{installer_base}}
    end
    
    private
    def upgrade
      cp '/etc/resolv.conf', nfsroot( 'etc/resolv.conf' ), {:preserve => true }
      cp '/etc/resolv.conf', nfsroot( 'etc/resolv.conf-lucieserver' ), {:preserve => true }
      File.open( nfsroot( 'etc/apt/apt.conf' ), 'w+' ) do |file|
        file.puts 'APT::Cache-Limit "100000000";'
      end
      sh %{chroot #{@top_dir} apt-get update}
      sh %{chroot #{@top_dir} apt-get -fyu install}
      sh %{chroot #{@top_dir} apt-get check}
      rm_rf nfsroot( 'etc/apm' )
      sh %{mount -t proc /proc #{nfsroot( 'proc' )}} rescue nil

      dpkg_divert '/etc/init.d/rcS' rescue nil
      dpkg_divert '/sbin/start-stop-daemon' rescue nil
      dpkg_divert '/sbin/discover-modprobe' rescue nil
      
      File.open( nfsroot( 'sbin/lucie-start-stop-daemon' ), 'w+' ) do |file|
        file.puts <<-START_STOP_DAEMON
for opt in "$@" ; do
    case "$opt" in
        --oknodo) oknodo=1 ;;
        --start) start=1 ;;
        --stop) stop=1 ;;
        esac
done

[ -n "$stop" -a -z "$oknodo" ] && exit 1

exit 0
        START_STOP_DAEMON
      end
      sh %{chmod +x #{nfsroot( 'sbin/lucie-start-stop-daemon' )}}
      ln_sf '/sbin/lucie-start-stop-daemon', nfsroot( 'sbin/start-stop-daemon' )
      sh %{chroot #{@top_dir} apt-get -y dist-upgrade}
    end
    
    private
    def dpkg_divert( fileNameString )
      sh %{LC_ALL=C chroot #{@top_dir} dpkg-divert --quiet --package lucie --add --rename #{fileNameString}}
    end
    
    private
    def save_all_packages_list
      sh %{chroot #{@top_dir} dpkg --get-selections | egrep 'install$' | awk '{print $1}' > #{nfsroot( 'var/tmp/base-packages.list' )}}
    end
    
    # hoaks some packages
    # liloconfig, dump and raidtool2 need these files
    private
    def hoax_some_packages
      File.open( nfsroot( 'etc/fstab' ), 'w+' ) do |file|
        file.puts "#UNCONFIGURED FSTAB FOR BASE SYSTEM"
      end
      touch nfsroot( 'etc/raidtab' )
      mkdir_p nfsroot( 'lib/modules/2.2.18' ) # FIXME: kernel version = '2.2.18'
      touch nfsroot( 'lib/modules/2.2.18/modules.dep' )
      File.open( nfsroot( 'etc/default/ntp-servers' ), 'w+' ) do |file|
        file.puts 'NTPSERVERS=""'
      end
      
      mkdir nfsroot( 'var/state' ) rescue nil
      cp '/etc/apt/sources.list', nfsroot( 'etc/apt/sources.list' )
      cp '/etc/apt/preferences',  nfsroot( 'etc/apt/preferences' ) rescue nil
      
      File.open( nfsroot( 'etc/hosts' ), 'w+' ) do |file|
        file.puts "127.0.0.1 localhost"
      end         
    end
    
    private
    def nfsroot_target
      return nfsroot( 'lucie/timestamp' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: