#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'
require 'rake'
require 'rake/tasklib'

Lucie::update(%q$Id$)

module Rake
  class NfsrootTask < TaskLib
    # NFSroot を作成するトップディレクトリ
    NFSROOT_DIR = '/var/lib/lucie/nfsroot/'.freeze 
    # インストール時に使用する設定名。通常は設定名 == インストーラ名。
    # 差分インストーラ作成の時には設定名 != インストーラ名 となるため、この設定名が必要となる。
    CONFIGURATION_NAME_STAMP = '/etc/lucie/.configuration_name'.freeze 
    # インストール時のインストーラの名前
    INSTALLER_NAME_STAMP = '/etc/lucie/.installer_name'.freeze 
    # LMP リポジトリが設置してあるサーバの名前
    LMP_SERVER = 'lucie-dev.titech.hpcc.jp'

    # NFSroot が作成されるディレクトリ
    attr_accessor :dir
    # ディストリビューションのバージョン
    attr_accessor :distribution_version
    # NFSroot に追加インストールするパッケージの Array
    attr_accessor :extra_packages
    # NFSroot の基となるベースシステム (xxx.tgz) のフルパス
    attr_accessor :installer_base
    # インストーラ実行用のカーネルパッケージのフルパス
    attr_accessor :kernel_package
    # インストーラ実行用のカーネルパッケージのバージョン
    attr_accessor :kernel_version
    # NFSroot の名前
    attr_accessor :name
    # パッケージサーバの URI
    attr_accessor :package_server
    # root パスワードを暗号化したもの
    attr_accessor :root_password
    # 差分インストールの元となるインストーラ名の Array
    attr_accessor :source_installer

    # 
    # 以下のようにすることで '/var/lib/lucie/nfsroot/my_installer' 以
    # 下に nfsroot を構築するための Task が定義される。
    #
    #  installer_name = 'my_installer'
    #  Rake::NfsrootTask.new( 'my_installer' ) do |nfsroot|
    #    nfsroot.dir = File.join( Rake::NfsrootTask::NFSROOT_DIR, installer_name )
    #    nfsroot.package_server = 'http://192.168.152.2:9999/debian'
    #    nfsroot.distribution_version = 'sarge'
    #    nfsroot.kernel_package = '/etc/lucie/kernel/kernel-image-2.4.27-fai_1_i386.deb'
    #    nfsroot.kernel_version = '2.4.27-fai'
    #    nfsroot.root_password = 'h29SP9GgVbLHE'
    #    nfsroot.installer_base = File.join( Rake::NfsrootTask::INSTALLER_BASE_DIR, 
    #                                        InstallerBaseTask.target_fname('debian', 'sarge' ))
    #    nfsroot.extra_packages = ['lv', 'libdevmapper1.01']
    #  end
    #
    public
    def initialize( name=:nfsroot ) # :yield: self
      @name = name
      @dir = NFSROOT_DIR
      @package_server = 'http://www.debian.or.jp/debian'
      @distribution_version = 'stable'
      @root_password = "h29SP9GgVbLHE"
      @extra_packages = nil
      @source_installer = nil
      yield self if block_given?
      define
    end
    
    private
    def define
      desc "Build the nfsroot filesytem using #{installer_base}"
      task @name
      
      desc "Remove the nfsroot filesystem"
      task paste("clobber_", @name) do
        info "Removing old nfsroot filesystem: #{@dir}"
        sh %{umount #{nfsroot( 'dev/pts' )} 1>/dev/null 2>&1}, sh_option rescue nil
        sh %{rm -rf #{nfsroot( '.??*' )} #{nfsroot( '*' )}}, sh_option
        sh %{[ -d #{@dir} ] && find #{@dir} ! -type d -xdev -maxdepth 1 | xargs -r rm -f}, sh_option rescue nil
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
        # TODO: setup_ssh
        install_kernel_nfsroot
        setup_dhcp
        make_stamp
      end
    end

    # INSTALLER_NAME_STAMP と CONFIGURATION_NAME_STAMP にスタンプファイルを作成する。
    # INSTALLER_NAME_STAMP の内容はインストーラ名。
    # CONFIGURATION_NAME_STAMP の内容は設定名 (設定ファイルとして用いるインストーラ名)
    # これは差分インストールの時にインストーラ名と設定名が一致しない場合に用いられる。
    private
    def make_stamp
      File.open( nfsroot(INSTALLER_NAME_STAMP), 'w+' ) do |file|
        file.print @name
      end
      File.open( nfsroot(CONFIGURATION_NAME_STAMP), 'w+' ) do |file|
        if @source_installer
          file.print @source_installer[0]
        else
          file.print @name
        end
      end
    end

    private
    def pxelinux_cfg_fname( ipString )
      return ipString.split('.').map do |each|
        sprintf( "%.2x", each ).upcase
      end.join
    end

    private
    def setup_dhcp
      info "Setting up DHCP and PXE environment."
      if @source_installer
        installer = Lucie::Config::Installer[@source_installer[0]]
      else
        installer = Lucie::Config::Installer[@name]
      end
      dhcp_server = installer.dhcp_server
      host_group = installer.host_group

      cp( nfsroot("boot/vmlinuz-#{@kernel_version}"),
          "/tftpboot/#{@name}", {:preserve => true}.merge(sh_option) )
      cp( "/usr/lib/syslinux/pxelinux.0", "/tftpboot", sh_option )
      pxelinux_cfg_dir = "/tftpboot/pxelinux.cfg.#{@name}"
      mkdir_p( pxelinux_cfg_dir, sh_option ) rescue nil
      host_group.members.each do |each|
        target = File.join( pxelinux_cfg_dir, pxelinux_cfg_fname( each.address ) )
        File::open( target, 'w+' ) do |file|
          file.puts "default #{@name}"
          file.puts
          file.puts "label #{@name}"
          file.puts "\tappend root=/dev/nfs nfsroot=#{@dir} ip=dhcp"
          file.puts "\tkernel #{@name}"
        end
        puts "Generated #{target}."
      end
      puts %{Generated #{pxelinux_cfg_dir}.}
      rm_f '/tftpboot/pxelinux.cfg', sh_option
      ln_s pxelinux_cfg_dir, '/tftpboot/pxelinux.cfg', sh_option

      dhcpd_conf_file = "/etc/dhcpd.conf.#{@name}"
      File.open( dhcpd_conf_file, 'w+' ) do |file|
        file.puts '# /etc/dhcpd.conf'
        file.puts "# dhcpd configuration for `#{@name}' generated by Lucie"
        file.puts
        file.puts 'deny unknown-clients;'
        file.puts 'option dhcp-max-message-size 2048;'
        file.puts 'use-host-decl-names on;'
        file.puts 'not authoritative;'
        file.puts '#always-reply-rfc1048 on;'
        file.puts
        file.puts "shared-network #{@name} {"
        file.puts indent{ "subnet #{dhcp_server.network} netmask #{dhcp_server.subnet} {" }
        file.puts indent{ indent{ "option root-path \"#{@dir}\";" }}
        file.puts indent{ indent{ "option domain-name-servers #{dhcp_server.dns};" }}
        file.puts indent{ indent{ "option domain-name \"#{dhcp_server.domain_name}\";" }}
        file.puts indent{ indent{ "option routers #{dhcp_server.gateway};" }}
        file.puts indent{ indent{ "option nis-domain \"#{dhcp_server.nis_domain_name}\";" }}
        file.puts        
        file.puts indent{ indent{ "# hostgroup `#{host_group.name}'" }} # comment
        host_group.members.each { |each|
          file.puts indent{ indent{ "host #{each.name} {" }}
          file.puts indent{ indent{ indent{ "hardware ethernet #{each.mac_address};" }}}
          file.puts indent{ indent{ indent{ "filename \"/tftpboot/pxelinux.0\";" }}}
          file.puts indent{ indent{ indent{ "fixed-address #{each.address};" }}}
          file.puts indent{ indent{ "}" }}
        }
        file.puts
        file.puts indent{ '}' }
        file.puts '}'
      end
      puts %{Generated #{dhcpd_conf_file}.}
      rm_f '/etc/dhcpd.conf', sh_option
      ln_s dhcpd_conf_file, '/etc/dhcpd.conf', sh_option
      puts %{Restarting DHCP daemon.}
      sh %{/etc/init.d/dhcp restart}, sh_option

      exports_file = "/etc/exports.#{@name}"
      File.open( exports_file, 'w+' ) do |file|
        file.puts '# /etc/exports'
        file.puts "# nfs server configuration for `#{@name}' generated by Lucie"
        host_group.members.each do |each|
          file.puts %{#{@dir} #{each.name}(ro,no_root_squash,async)}
        end
      end
      puts %{Generated "#{exports_file}".}
      rm_f '/etc/exports', sh_option
      ln_s exports_file, '/etc/exports', sh_option
      puts %{Restarting NFS daemon.}
      sh %{/etc/init.d/nfs-kernel-server restart}, sh_option
    end

    private
    def indent( tabString="\t" )
      sprintf '%s%s', tabString, yield
    end

    private
    def install_kernel_nfsroot
      # TODO: automatically determine kernel_version using filename.
      info "Installing kernel on nfsroot."
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
      ln_s  '/tmp/etc/syslogsocket', nfsroot('dev/log'), sh_option
      ln_sf '/tmp/etc/resolv.conf', nfsroot('etc/resolv.conf'), sh_option
      ln_sf '/tmp', nfsroot('etc/sysconfig'), sh_option
      ln_sf '../../sbin/rcS_lucie', nfsroot('etc/init.d/rcS'), sh_option
      ln_sf '/dev/null', nfsroot('etc/network/ifstate'), sh_option
      sh %{[ -d #{nfsroot('var/yp')} ] && ln -s /tmp/binding #{nfsroot('var/yp/binding')}}, sh_option rescue nil

      sh %{[ -d #{nfsroot('var/log/ksymoops')} ] && rm -rf #{nfsroot('var/log/ksymoops')}}, sh_option rescue nil
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
      info "Setting timezone in nfsroot."
      timezone = `readlink /etc/localtime | sed 's%^/usr/share/zoneinfo/%%'`.chomp
      sh %{echo #{timezone} > #{nfsroot('etc/timezone')}}
      sh %{rm -f #{nfsroot('etc/localtime')} && ln -sf /usr/share/zoneinfo/#{timezone} #{nfsroot('etc/localtime')}}, sh_option
    end
    
    private
    def add_additional_packages
      info "Adding additional packages to nfsroot."
      additional_packages = ['dhcp3-client', 'ruby1.8',
        'liblog4r-ruby', 'rake', 'perl-modules', 'discover',
        'libapt-pkg-perl', 'file', 'cfengine']
      sh_log %{chroot #{@dir} apt-get -y --fix-missing install #{additional_packages.join(' ')} </dev/null 2>&1}, sh_option, &apt_block
      if @extra_packages
        info "Adding extra packages to nfsroot: #{@extra_packages.join(', ')}"
        sh_log %{LC_ALL=C chroot #{@dir} apt-get -y --fix-missing install #{@extra_packages.join(' ')} </dev/null 2>&1}, sh_option, &apt_block
      end
      sh_log %{chroot #{@dir} apt-get clean}, sh_option, &apt_block
    end
    
    private
    def copy_lucie_files
      info "Copying lucie client files."
      sh %{ruby -pi -e "gsub(/^root::/, 'root:#{@root_password}:')" #{nfsroot('etc/passwd')}}, sh_option

      Lucie::Logger::instance.info "Generating apt.conf on nfsroot"      
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
      Lucie::Logger::instance.info "DONE"

      dpkg_divert '/etc/dhcp3/dhclient-script' rescue nil
      dpkg_divert '/etc/dhcp3/dhclient.conf' rescue nil      
      sh_log %{chroot #{@dir} apt-get install lucie-client}, sh_option, &apt_block
      sh %{chroot #{@dir} cp -p /usr/share/lucie/etc/dhclient.conf /etc/dhcp3/}, sh_option
      cp '/etc/lucie/resource.rb', nfsroot('etc/lucie'), sh_option
      if @source_installer
        sh %{cp -Rp /etc/lucie/#{@source_installer[0]}/* #{nfsroot('etc/lucie')}}, sh_option
      else
        sh %{cp -Rp /etc/lucie/#{name}/* #{nfsroot('etc/lucie')}}, sh_option rescue nil # FIXME: /etc/lucie/[インストーラ名] が空のときを rescue
      end
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-script /etc/dhcp3/}, sh_option      
      sh %{chroot #{@dir} cp -p /usr/lib/lucie/dhclient-perl /sbin/}, sh_option      
      sh %{chroot #{@dir} pwconv}, sh_option
    end
    
    private
    def extract_installer_base
      info "Extracting installer base tarball. This may take a long time."
      sh %{tar -C #{@dir} -xzf #{installer_base}}, sh_option
      cp installer_base, nfsroot( '/var/tmp' ), sh_option
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
      info "Upgrading nfsroot. This may take a long time."
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
      
      Lucie::Logger::instance.info "Generating fake start-stop-daemon"      
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
      Lucie::Logger::instance.info "DONE"
      sh %{chmod +x #{nfsroot( 'sbin/lucie-start-stop-daemon' )}}, sh_option
      ln_sf '/sbin/lucie-start-stop-daemon', nfsroot( 'sbin/start-stop-daemon' ), sh_option
      sh_log %{chroot #{@dir} apt-get -y dist-upgrade}, sh_option, &apt_block
    end
    
    private
    def dpkg_divert( fileNameString )
      sh %{LC_ALL=C chroot #{@dir} dpkg-divert --quiet --package lucie-client --add --rename #{fileNameString} 2>/dev/null}, sh_option
    end
    
    private
    def save_all_packages_list
      sh %{chroot #{@dir} dpkg --get-selections | egrep 'install$' | awk '{print $1}' > #{nfsroot( 'var/tmp/base-packages.list' )}}, sh_option
    end
    
    private
    def hoax_some_packages
      info "Modifying nfsroot to avoid errors caused by some packages."
      sh %{echo "#UNCONFIGURED FSTAB FOR BASE SYSTEM" > #{nfsroot('etc/fstab')}}
      touch nfsroot( 'etc/raidtab' ), sh_option

      mkdir_p nfsroot( "lib/modules/#{@kernel_version}" ), sh_option
      touch nfsroot( "lib/modules/#{@kernel_version}/modules.dep" ), sh_option
      lucie_server_kernel_version=`uname -r`.chomp
      mkdir_p nfsroot( "lib/modules/#{lucie_server_kernel_version}" ), sh_option
      touch nfsroot( "lib/modules/#{lucie_server_kernel_version}/modules.dep" ), sh_option
      
      sh %{echo 'NTPSERVERS=""' > #{nfsroot('etc/default/ntp-servers')}}
      
      mkdir nfsroot( 'var/state' ), sh_option rescue nil

      Lucie::Logger::instance.info "Generating sources.list on nfsroot"
      File.open( nfsroot('etc/apt/sources.list'), 'w+' ) do |file|
        file.puts "deb #{@package_server} #{@distribution_version} main contrib non-free"
        file.puts "# lucie-client package"
        file.puts "deb http://#{LMP_SERVER}/packages/lucie-client/debian/#{@distribution_version}/ ./"
        file.puts "# lucie meta package"
        file.puts "deb http://#{LMP_SERVER}/packages/lmp/ ./"
      end
      Lucie::Logger::instance.info "DONE"

      sh %{echo "127.0.0.1 localhost" >> #{nfsroot('etc/hosts')}}
      # FIXME: lookup IP address on each lucie-setup.
      sh %{echo "163.220.99.220 #{LMP_SERVER}" >> #{nfsroot('etc/hosts')}}

      cp '/etc/apt/preferences',  nfsroot('etc/apt/preferences'), sh_option rescue nil      
    end
    
    private
    def nfsroot_target
      return nfsroot( 'lucie/timestamp' )
    end

    private
    def sh_option
       return {:verbose => Lucie::CommandLineOptions.instance.verbose} 
    end

    private
    def info( aString )
      Lucie::Logger::instance.info aString
      puts aString
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
