#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'
require 'rake/tasklib'

module Rake
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
      define
    end
    
    private
    def define
      desc "Build the nfsroot filesytem using #{installer_base}"
      task @name
      
      
      desc "Remove the nfsroot filesystem"
      task paste("clobber_", @name) do
        sh %{umount #{File.join( @dir, 'dev/pts' )} 1>/dev/null 2>&1} rescue nil
        sh %{rm -rf #{File.join( @dir, '.??*' )} #{File.join( @dir, '*' )}} rescue nil
        sh %{find #{@dir} ! -type d -xdev -maxdepth 1 | xargs -r rm -f} 
      end
      
      directory @dir
      task @name => nfsroot_target
      
      file nfsroot_target => [paste("clobber_", @name), @dir] do
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
      return File.join( @dir, filePathName )
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
      sh %{tar -C #{@dir} -xzf #{installer_base}}
    end
    
    private
    def upgrade
      cp '/etc/resolv.conf', File.join( @dir, 'etc/resolv.conf' ), {:preserve => true }
      cp '/etc/resolv.conf', File.join( @dir, 'etc/resolv.conf-lucieserver' ), {:preserve => true }
      File.open( File.join( @dir, 'etc/apt/apt.conf' ), 'w+' ) do |file|
        file.puts 'APT::Cache-Limit "100000000";'
      end
      sh %{chroot #{@dir} apt-get update}
      sh %{chroot #{@dir} apt-get -fyu install}
      sh %{chroot #{@dir} apt-get check}
      rm_rf File.join( @dir, 'etc/apm' )
      sh %{mount -t proc /proc #{File.join( @dir, 'proc' )}} rescue nil

      dpkg_divert '/etc/init.d/rcS' rescue nil
      dpkg_divert '/sbin/start-stop-daemon' rescue nil
      dpkg_divert '/sbin/discover-modprobe' rescue nil
      
      File.open( File.join( @dir, 'sbin/lucie-start-stop-daemon' ), 'w+' ) do |file|
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
      sh %{chmod +x #{File.join( @dir, 'sbin/lucie-start-stop-daemon' )}}
      ln_sf '/sbin/lucie-start-stop-daemon', File.join( @dir, 'sbin/start-stop-daemon' )
      sh %{chroot #{@dir} apt-get -y dist-upgrade}
    end
    
    private
    def dpkg_divert( fileNameString )
      sh %{LC_ALL=C chroot #{@dir} dpkg-divert --quiet --package lucie --add --rename #{fileNameString}}
    end
    
    private
    def save_all_packages_list
      sh %{chroot #{@dir} dpkg --get-selections | egrep 'install$' | awk '{print $1}' > #{File.join( @dir, 'var/tmp/base-packages.list' )}}
    end
    
    # hoaks some packages
    # liloconfig, dump and raidtool2 need these files
    private
    def hoax_some_packages
      File.open( File.join( @dir, 'etc/fstab' ), 'w+' ) do |file|
        file.puts "#UNCONFIGURED FSTAB FOR BASE SYSTEM"
      end
      touch File.join( @dir, 'etc/raidtab' )
      mkdir_p File.join( @dir, 'lib/modules/2.2.18' ) # FIXME: kernel version = '2.2.18'
      touch File.join( @dir, 'lib/modules/2.2.18/modules.dep' )
      File.open( File.join( @dir, 'etc/default/ntp-servers' ), 'w+' ) do |file|
        file.puts 'NTPSERVERS=""'
      end
      
      mkdir File.join( @dir, 'var/state' ) rescue nil
      cp '/etc/apt/sources.list', File.join( @dir, 'etc/apt/sources.list' )
      cp '/etc/apt/preferences',  File.join( @dir, 'etc/apt/preferences' ) rescue nil
      
      File.open( File.join( @dir, 'etc/hosts' ), 'w+' ) do |file|
        file.puts "127.0.0.1 localhost"
      end         
    end
    
    private
    def nfsroot_target
      return File.join( @dir + 'lucie/timestamp' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: