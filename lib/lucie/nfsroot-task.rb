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
        sh %{umount #{nfsroot( 'dev/pts' )} 1>/dev/null 2>&1}, sh_option rescue nil
        sh %{rm -rf #{nfsroot( '.??*' )} #{nfsroot( '*' )}}, sh_option rescue nil
        sh %{find #{@dir} ! -type d -xdev -maxdepth 1 | xargs -r rm -f}, sh_option 
      end
      
      directory @dir
      task @name => nfsroot_target
      
      file nfsroot_target => [paste("clobber_", @name), @dir] do
        ENV['LC_ALL'] = 'C'
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
      puts "Setting up DHCP and PXE environment."
      cp( nfsroot("boot/vmlinuz-#{@kernel_version}"),
          "/tftpboot/#{@name}", {:preserve => true}.merge(sh_option) )
      cp( "/usr/lib/syslinux/pxelinux.0", "/tftpboot", sh_option )
      mkdir_p( "/tftpboot/pxelinux.cfg", sh_option ) rescue nil
    end

    private
    def install_kernel_nfsroot
      puts "Installing kernel on nfsroot."
      rm_rf nfsroot("boot/*-#{@kernel_version}"), sh_option
      rm_rf nfsroot("lib/modules/#{@kernel_version}"), sh_option
      sh %{echo "do_boot_enable=no" > #{nfsroot('etc/kernel-img.conf')}}, sh_option
      sh %{dpkg -x #{@kernel_package} #{@dir}}, sh_option
      sh %{umount #{nfsroot('proc')}}, sh_option rescue nil
      sh %{chroot #{@dir} update-modules}, sh_option
      sh %{chroot #{@dir} depmod -qaF /boot/System.map-#{@kernel_version} #{@kernel_version} || true}, sh_option
    end
    
    # make little changes to nfsroot. because nfsroot is
    # read only for the install clients.
    private 
    def make_symlinks
      rm_rf [nfsroot('etc/mtab'), nfsroot('var/run'), nfsroot('etc/sysconfig')], sh_option
      ln_s  '/proc/mounts', nfsroot('etc/mtab'), sh_option
      ln_s  '/tmp/var/run', nfsroot('var/run'), sh_option
      ln_sf '/tmp/var/state/discover', nfsroot('var/state/discover'), sh_option
      ln_sf '/tmp/var/lib/discover', nfsroot('var/lib/discover'), sh_option
      ln_sf '/tmp/etc/syslogsocket', nfsroot('dev/log'), sh_option
      ln_sf '/tmp/etc/resolv.conf', nfsroot('etc/resolv.conf'), sh_option
      ln_sf '/tmp', nfsroot('etc/sysconfig'), sh_option
      ln_sf '../../sbin/rcS_lucie', nfsroot('etc/init.d/rcS'), sh_option
      ln_sf '/dev/null', nfsroot('etc/network/ifstate'), sh_option
      ln_s  '/tmp/binding', nfsroot('var/yp/binding'), sh_option rescue nil
      rmdir nfsroot('var/log/ksymoops'), sh_option rescue nil
      ln_s  '/dev/null', nfsroot('var/log/ksymoops'), sh_option
      sh %{echo "iface lo inet loopback" > #{nfsroot( 'etc/network/interfaces' )}}, sh_option
      sh %{echo "*.* /tmp/lucie/syslog.log" > #{nfsroot( 'etc/syslog.conf' )}}, sh_option
    end
    
    private
    def nfsroot( filePathName )
      return File.join( @dir, filePathName )
    end
    
    private
    def set_timezone
      puts "Setting timezone in nfsroot."
      timezone = `readlink /etc/localtime | sed 's%^/usr/share/zoneinfo/%%'`.chomp
      File.open( nfsroot('etc/timezone'), 'w+' ) do |file|
        file.puts timezone
      end
      rm_f nfsroot( 'etc/localtime' ), sh_option
      ln_sf "/usr/share/zoneinfo/#{timezone}", nfsroot( 'etc/localtime' ), sh_option
    end
    
    private
    def add_additional_packages
      puts "Adding additional packages to nfsroot."
      sh_log %{chroot #{@dir} apt-get -y --fix-missing install dhcp3-client}, sh_option, &apt_block
      sh_log %{chroot #{@dir} apt-get clean}, sh_option, &apt_block
    end
    
    private
    def copy_lucie_files
      puts "Copying lucie client files."
      sh %{ruby -pi -e "gsub(/^root::/, 'root:#{@root_password}:')" #{nfsroot('etc/passwd')}}, sh_option
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
      sh_log %{chroot #{@dir} apt-get install lucie-client}, sh_option, &apt_block
      sh %{chroot #{@dir} cp -p /usr/share/lucie/etc/dhclient.conf /etc/dhcp3/}, sh_option
      sh %{cp -Rp /etc/lucie/* #{nfsroot('etc/lucie')}}, sh_option
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-script /etc/dhcp3/}, sh_option      
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-perl /sbin/}, sh_option      
      sh %{chroot #{@dir} pwconv}, sh_option
    end
    
    private
    def extract_installer_base
      puts "Extracting installer base tarball. This may take a long time."
      sh %{tar -C #{@dir} -xzf #{installer_base}}, sh_option
    end

    private
    def apt_block
      return lambda do |rd|
        while (rd.gets)
          Lucie::Logger::instance.debug $_.chomp
        end
      end
    end
    
    private
    def upgrade
      puts "Upgrading nfsroot. This may take a long time."
      cp( '/etc/resolv.conf', nfsroot( 'etc/resolv.conf-lucieserver' ),
          {:preserve => true }.merge( sh_option ))
      cp( '/etc/resolv.conf', nfsroot( 'etc/resolv.conf' ),
          {:preserve => true }.merge( sh_option ))
      File.open( nfsroot( 'etc/apt/apt.conf' ), 'w+' ) do |file|
        file.puts 'APT::Cache-Limit "100000000";'
      end
      sh_log %{chroot #{@dir} apt-get update 2>&1}, sh_option, &apt_block
      sh_log %{chroot #{@dir} apt-get -fyu install 2>&1}, sh_option, &apt_block
      sh_log %{chroot #{@dir} apt-get check 2>&1}, sh_option, &apt_block
      rm_rf nfsroot( 'etc/apm' ), sh_option
      sh %{mount -t proc /proc #{nfsroot( 'proc' )}}, sh_option rescue nil

      dpkg_divert '/etc/init.d/rcS' rescue nil
      dpkg_divert '/sbin/start-stop-daemon' rescue nil
      dpkg_divert '/sbin/discover-modprobe' rescue nil
      
      File.open( nfsroot( 'sbin/lucie-start-stop-daemon' ), 'w+' ) do |file|
        file.puts <<-START_STOP_DAEMON
#! /bin/bash

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
      sh %{chmod +x #{nfsroot( 'sbin/lucie-start-stop-daemon' )}}, sh_option
      ln_sf '/sbin/lucie-start-stop-daemon', nfsroot( 'sbin/start-stop-daemon' ), sh_option
      sh_log %{chroot #{@dir} apt-get -y dist-upgrade}, sh_option, &apt_block
    end
    
    private
    def dpkg_divert( fileNameString )
      sh %{LC_ALL=C chroot #{@dir} dpkg-divert --quiet --package lucie-client --add --rename #{fileNameString}}, sh_option
    end
    
    private
    def save_all_packages_list
      sh %{chroot #{@dir} dpkg --get-selections | egrep 'install$' | awk '{print $1}' > #{nfsroot( 'var/tmp/base-packages.list' )}}, sh_option
    end
    
    # hoaks some packages
    # liloconfig, dump and raidtool2 need these files
    #
    # * raidtool2: 空の /etc/fstab, /etc/raidtab を作成
    # * lvm: 空の /lib/modules/カーネルバージョン, /lib/modules/カーネルバージョン/modules.dep を作成
    # * /etc/default/ntp-servers
    # * /var/state
    # * apt-get: /etc/hosts に localhost, lucie.sourceforge.net を追加, /etc/apt/sources-list を作成, /etc/apt/preferences をコピー
    # 
    private
    def hoax_some_packages
      puts "Modifying nfsroot to avoid errors specific to some packages."
      File.open( nfsroot( 'etc/fstab' ), 'w+' ) do |file|
        file.puts "#UNCONFIGURED FSTAB FOR BASE SYSTEM"
      end
      touch nfsroot( 'etc/raidtab' ), sh_option

      mkdir_p nfsroot( "lib/modules/#{@kernel_version}" ), sh_option
      touch nfsroot( "lib/modules/#{@kernel_version}/modules.dep" ), sh_option

      File.open( nfsroot( 'etc/default/ntp-servers' ), 'w+' ) do |file|
        file.puts 'NTPSERVERS=""'
      end
      
      mkdir nfsroot( 'var/state' ), sh_option rescue nil

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
      cp '/etc/apt/preferences',  nfsroot( 'etc/apt/preferences' ), sh_option rescue nil      
    end
    
    private
    def nfsroot_target
      return nfsroot( 'lucie/timestamp' )
    end

    private
    def sh_option
       return {:verbose => Lucie::CommandLineOptions.instance.verbose} 
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: