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
  #     nfsroot.package_server = "http://www.debian.or.jp/debian"
  #     nfsroot.distribution_version = "woody"
  #     nfsroot.kernel_package = "/etc/lucie/kernel/kernel-image-2.4.27-fai_1_i386.deb"
  #     nfsroot.kernel_version = "2.2.18"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
  #     installer_base.root_password = "h29SP9GgVbLHE"
  #   end
  #
  # 作成する InstallerBaseTask にはデフォルトの名前以外に自分の好きな名前を
  # つけることもできる。
  #
  #   NfsrootTask.new( :presto_installer ) do |nfsroot|
  #     nfsroot.dir = "tmp"
  #     nfsroot.package_server = "http://www.debian.or.jp/debian"
  #     nfsroot.distribution_version = "woody"
  #     nfsroot.kernel_package = "/etc/lucie/kernel/kernel-image-2.4.27-fai_1_i386.deb"
  #     nfsroot.kernel_version = "2.2.18"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
  #     installer_base.root_password = "h29SP9GgVbLHE"
  #   end
  #
  #
  #
  class NfsrootTask < TaskLib
    attr_accessor :name
    attr_accessor :dir
    attr_accessor :installer_base
    attr_accessor :package_server
    attr_accessor :distribution_version
    attr_accessor :kernel_package
    attr_accessor :kernel_version
    attr_accessor :root_password
    
    # Nfsroot タスクを作成する。
    public
    def initialize( name=:nfsroot ) # :yield: self
      @name = name
      @dir = '/var/lib/lucie/nfsroot/'
      @package_server = 'http://www.debian.or.jp/debian'
      @distribution_version = 'stable'
      @root_password = "h29SP9GgVbLHE"
      yield self if block_given?
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
        sh %{find #{@dir} ! -type d -xdev -maxdepth 1 | xargs -r rm -f} 
      end
      
      directory @dir
      task @name => nfsroot_target
      
      file nfsroot_target => [paste("clobber_", @name), @dir] do
        extract_installer_base        
        hoax_some_packages
        upgrade
        add_additional_packages
        copy_lucie_files
        set_timezone
        make_symlinks
        save_all_packages_list
        install_kernel_nfsroot
        setup_dhcp
      end
    end

    private
    def setup_dhcp
      cp( nfsroot("boot/vmlinuz-#{@kernel_version}"),
          "/tftpboot/#{@name}", :preserve => true )
      cp( "/usr/lib/syslinux/pxelinux.0", "/tftpboot" )
      mkdir_p( "/tftpboot/pxelinux.cfg" ) rescue nil
    end

    private
    def install_kernel_nfsroot
      rm_rf nfsroot("boot/*-#{@kernel_version}")
      rm_rf nfsroot("lib/modules/#{@kernel_version}")
      sh %{echo "do_boot_enable=no" > #{nfsroot('etc/kernel-img.conf')}}
      sh %{dpkg -x #{@kernel_package} #{@dir}}
      sh %{umount #{nfsroot('proc')}} rescue nil
      sh %{chroot #{@dir} update-modules}
      sh %{chroot #{@dir} depmod -qaF /boot/System.map-#{@kernel_version} #{@kernel_version} || true}
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
      sh %{echo "iface lo inet loopback" > #{nfsroot( 'etc/network/interfaces' )}}
      sh %{echo "*.* /tmp/lucie/syslog.log" > #{nfsroot( 'etc/syslog.conf' )}}
    end
    
    private
    def nfsroot( filePathName )
      return File.join( @dir, filePathName )
    end
    
    private
    def set_timezone
      timezone = `readlink /etc/localtime | sed 's%^/usr/share/zoneinfo/%%'`.chomp
      File.open( nfsroot('etc/timezone'), 'w+' ) do |file|
        file.puts timezone
      end
      rm_f nfsroot( 'etc/localtime' )
      ln_sf "/usr/share/zoneinfo/#{timezone}", nfsroot( 'etc/localtime' )
    end
    
    private
    def add_additional_packages
      sh %{chroot #{@dir} apt-get -y --fix-missing install dhcp3-client}
      sh %{chroot #{@dir} apt-get clean}
    end
    
    private
    def copy_lucie_files
      sh %{ruby -pi -e "gsub(/^root::/, 'root:#{@root_password}:')" #{nfsroot('etc/passwd')}}
      File.open( nfsroot( 'etc/apt/apt.conf' ), 'w+' ) do |file|
        file.print <<-APT_CONF
APT 
{
  Cache-Limit "100000000";
  Get 
  {
     Assume-Yes "true";     
     Fix-Missing "true";     
     Show-Upgraded "true";
     Purge "true";		// really purge! Also removes config files
     List-Cleanup "true";
     ReInstall "false";
  };
};

DPkg 
{
  Options {
	  "--abort-after=4711";	  // a magic number in cologne ;-)
	  "--force-confnew";
	  }
};
        APT_CONF
      end
      dpkg_divert '/etc/dhcp3/dhclient-script' rescue nil
      dpkg_divert '/etc/dhcp3/dhclient.conf' rescue nil      
      sh %{chroot #{@dir} apt-get install lucie-client}
      sh %{chroot #{@dir} cp -p /usr/share/lucie/etc/dhclient.conf /etc/dhcp3/}
      sh %{cp -Rpv /etc/lucie/* #{nfsroot('etc/lucie')}}
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-script /etc/dhcp3/}      
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-perl /sbin/}      
      sh %{chroot #{@dir} pwconv}
    end
    
    private
    def extract_installer_base
      sh %{tar -C #{@dir} -xzf #{installer_base}}
    end
    
    private
    def upgrade
      cp '/etc/resolv.conf', nfsroot( 'etc/resolv.conf-lucieserver' ), {:preserve => true }
      File.open( nfsroot( 'etc/apt/apt.conf' ), 'w+' ) do |file|
        file.puts 'APT::Cache-Limit "100000000";'
      end
      sh %{chroot #{@dir} apt-get update}
      sh %{chroot #{@dir} apt-get -fyu install}
      sh %{chroot #{@dir} apt-get check}
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
      sh %{chroot #{@dir} apt-get -y dist-upgrade}
    end
    
    private
    def dpkg_divert( fileNameString )
      sh %{LC_ALL=C chroot #{@dir} dpkg-divert --quiet --package lucie-client --add --rename #{fileNameString}}
    end
    
    private
    def save_all_packages_list
      sh %{chroot #{@dir} dpkg --get-selections | egrep 'install$' | awk '{print $1}' > #{nfsroot( 'var/tmp/base-packages.list' )}}
    end
    
    # hoaks some packages
    # liloconfig, dump and raidtool2 need these files
    private
    def hoax_some_packages
      File.open( nfsroot( 'etc/fstab' ), 'w+' ) do |file|
        file.puts "#UNCONFIGURED FSTAB FOR BASE SYSTEM"
      end
      touch nfsroot( 'etc/raidtab' )
      mkdir_p nfsroot( "lib/modules/#{@kernel_version}" )
      touch nfsroot( "lib/modules/#{@kernel_version}/modules.dep" )
      File.open( nfsroot( 'etc/default/ntp-servers' ), 'w+' ) do |file|
        file.puts 'NTPSERVERS=""'
      end
      
      mkdir nfsroot( 'var/state' ) rescue nil
      File.open( nfsroot( 'etc/apt/sources.list' ), 'w+' ) do |file|
        file.puts "deb #{@package_server} #{@distribution_version} main contrib non-free"
        file.puts "deb #{@package_server}-non-US #{@distribution_version}/non-US main contrib non-free"
        file.puts "# lucie-client package"
        file.puts "deb http://lucie.sourceforge.net/packages/lucie-client/sarge/ ./"
      end            
      File.open( nfsroot( 'etc/hosts' ), 'w+' ) do |file|
        file.puts "127.0.0.1 localhost"
        file.puts "66.35.250.209 lucie.sourceforge.net"
      end   
      cp '/etc/apt/preferences',  nfsroot( 'etc/apt/preferences' ) rescue nil      
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