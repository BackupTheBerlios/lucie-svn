#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'lucie/time-stamp'

$sh_option     = {:verbose=>true}
$lucie_root    = '/tmp/target'
$local_package_dir = '/etc/lucie/local_package'
$file_dir          = '/etc/lucie/file'
$kernel_dir        = '/etc/lucie/kernel'
$script_dir        = '/etc/lucie/script'
# directory where temporary log files are stored.
$logdir        = '/tmp/lucie'
$lucie_log     = File.join( $logdir, 'lucie.log' )
$diskvar       = File.join( $logdir, 'disk_var.sh' )
$dmesg_log     = File.join( $logdir, 'dmesg.log' )
$format_log    = File.join( $logdir, 'format.log' )
$modules_log   = File.join( $logdir, 'modules.log' )
$kernel_log    = File.join( $logdir, 'kernel.log' )
$software_log  = File.join( $logdir, 'software.log' )

module Lucie
  update(%q$Id$)

  module Installer
    # インストーラを初期化する
    public
    def init
      create_ramdisk
      ENV['DEBIAN_FRONTEND'] = 'noninteractive'
      File.umask(022)
      sh( %{grep -q '[[:space:]]sysfs' /proc/filesystems && mount -t sysfs sysfs /sys}, $sh_option ) rescue nil
      sh( %{ifup lo}, $sh_option ) rescue nil
      sh( %{[ -x /sbin/portmap ] && /sbin/portmap}, $sh_option ) rescue nil
      sh( %{mount -t devpts devpts /dev/pts}, $sh_option )
      # add other options for nfs mount of /dev/root to root-path in dhcpd.conf
      sh( %{mount -o remount,noatime,ro /dev/root /}, $sh_option )
      sh( %{cat /proc/kmsg >/dev/tty4 &}, $sh_option )
      save_dmesg
    end

    public
    def save_dmesg
      sh( %{dmesg > #{$dmesg_log}}, $sh_option )
    end

    # インストーラ環境に必須な ramdisk を作成し、ログを ON にする
    private
    def create_ramdisk
      sh( %{mount -n -t proc proc /proc}, $sh_option )
      sh( %{[ -c /dev/.devfsd ] && /sbin/devfsd /dev}, $sh_option ) rescue nil # start devfsd if needed
      rc = sh( %{mount -t tmpfs tmpfs /tmp}, $sh_option ) # if we have shm use it as ramdisk
      unless rc
        ramdevice='/dev/ram0'
        sh( %{mke2fs -q -m 0 #{ramdevice}}, $sh_option )
        sh( %{mount -n #{ramdevice} /tmp}, $sh_option )
      end
      
      # now create the required subdirectories
      mkdir_p( '/tmp/etc', $sh_option )
      mkdir_p( $lucie_root, $sh_option )
      mkdir_p( '/tmp/var/run/sshd', $sh_option )
      mkdir_p( '/tmp/var/state/discover', $sh_option )
      mkdir_p( '/tmp/var/lib/discover', $sh_option )
      
      mkdir( '/tmp/var/tmp', $sh_option )
      mkdir( '/tmp/var/log', $sh_option )
      mkdir( '/tmp/var/lock', $sh_option )
      mkdir( '/tmp/var/spool', $sh_option )
      
      mkdir_p( $logdir, $sh_option )
      
      require 'lucie/command-line-options'
      CommandLineOptions.instance.parse( [%{--log-file=#{$lucie_log}}, %{--logging-level=DEBUG}] )
      require 'lucie/logger' # now we can log into $logdir
    end

    # diversion を加える
    public
    def add_divert( fname )
      diverted = File.join($lucie_root, fname)
      sh %{chroot #{$lucie_root} dpkg-divert --package lucie-client --rename --add #{fname}}, $sh_option
      File.open( diverted, 'w+' ) do |file|
        file.print <<-EOF
#! /bin/sh
# diversion of #{fname} crated by Lucie
exit 0
    EOF
      end 
      sh %{chmod a+rx #{diverted}}, $sh_option
    end

    # インストーラ情報を返す
    public
    def installer_resource
      require '/etc/lucie/resource.rb'
      return Config::Installer[installer_name]
    end

    private
    def installer_name
      return %x(cat /etc/lucie/.installer_name)
    end
    
    # DHCP サーバ情報を返す
    public
    def dhcp_server_resource
      return installer_resource.dhcp_server
    end

    # ホストグループ情報を返す
    public
    def host_group_resource
      return installer_resource.host_group
    end

    # ホスト情報を返す
    public
    def host_resource
      require '/etc/lucie/resource.rb'
      return Config::Host[`hostname`.chomp]
    end

    # ターゲット上のファイルパスを返す
    public
    def target( fileNameString )
      return File.join( $lucie_root, fileNameString )
    end
  end         
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
