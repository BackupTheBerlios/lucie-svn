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
  # �C���X�g�[���� NFSROOT ���r���h����^�X�N�𐶐�����B
  #
  # NfsrootTask �͎��̃^�[�Q�b�g���쐬����:
  #
  # [<b><em>nfsroot</em></b>]
  #   Nfsroot �^�X�N�̃��C���^�X�N
  # [<b><em>:clobber_nfsroot</em></b>]
  #   ���ׂĂ� NFSROOT �֘A�t�@�C������������B
  #   ���̃^�[�Q�b�g�͎����I�Ƀ��C���� clobber �^�[�Q�b�g�ɒǉ������
  #
  # ��:
  #   NfsrootTask.new do |nfsroot|
  #     nfsroot.dir = "tmp"
  #     nfsroot.package_server = "http://www.debian.or.jp/debian"
  #     nfsroot.distribution_version = "woody"
  #     nfsroot.kernel_version = "2.2.18"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
  #   end
  #
  # �쐬���� InstallerBaseTask �ɂ̓f�t�H���g�̖��O�ȊO�Ɏ����̍D���Ȗ��O��
  # ���邱�Ƃ��ł���B
  #
  #   NfsrootTask.new( :presto_installer ) do |nfsroot|
  #     nfsroot.dir = "tmp"
  #     nfsroot.package_server = "http://www.debian.or.jp/debian"
  #     nfsroot.distribution_version = "woody"
  #     nfsroot.kernel_version = "2.2.18"
  #     nfsroot.installer_base = "/tmp/presto_cluster/var/tmp/debian_woody.tgz"
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
    attr_accessor :kernel_version
    
    # Nfsroot �^�X�N���쐬����B
    public
    def initialize( name=:nfsroot ) # :yield: self
      @name = name
      @dir = '/var/lib/lucie/nfsroot/'
      @package_server = 'http://www.debian.or.jp/debian'
      @distribution_version = 'stable'
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
    end
    
    private
    def copy_lucie_files
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
      sh %{LC_ALL=C chroot #{@dir} dpkg-divert --quiet --package lucie --add --rename #{fileNameString}}
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
      end            
      File.open( nfsroot( 'etc/hosts' ), 'w+' ) do |file|
        file.puts "127.0.0.1 localhost"
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