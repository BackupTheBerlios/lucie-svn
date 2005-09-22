#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# ftp and http needs resolv.conf in chroot environment, /etc/hosts is useful
# think about using fcopy for these two files
sh( %{[ -f /tmp/etc/resolv.conf ] && cp /tmp/etc/resolv.conf #{target('etc')}}, $sh_option ) rescue nil
sh( %{[ -f /etc/hosts ] && cp /etc/hosts #{target('etc')}}, $sh_option )

# set hostname in $lucie_root
hostname = `hostname`.chomp
ip_address = Lucie::Config::Host[hostname].address
domain = installer_resource.dhcp_server.domain_name

sh( %{echo -e "#{ip_address}\t#{hostname}.#{domain} #{hostname}" >>#{target('etc/hosts')}}, $sh_option )
sh( %{echo #{hostname} >#{target('etc/hostname')}}, $sh_option )
sh( %{cp /etc/apt/* #{target('etc/apt')} || true}, $sh_option )

File.open( target('etc/apt/sources.list'), 'w+' ) do |file|
  file.puts "deb #{installer_resource.package_server.uri} #{installer_resource.distribution_version} main contrib non-free"
  # TODO: sarge の non-US 廃止 ? にともなってコメントアウト。sarge かどうかで判断すべし。
#  file.puts "deb #{installer_resource.package_server.uri}-non-US #{installer_resource.distribution_version}/non-US main contrib non-free"
end            

# some packages must access /proc even in chroot environment
sh( %{mount -t proc proc #{target('proc')}}, $sh_option )

# if libc is upgraded init u is called in chroot environment and
# then init will eat up much cpu time
add_divert( '/sbin/init' )
add_divert( '/usr/sbin/liloconfig' )
add_divert( '/usr/sbin/invoke-rc.d' )

# fake some more programs
add_divert( '/etc/init.d/nis' )
add_divert( '/sbin/start-stop-daemon' )
cp( '/sbin/start-stop-daemon', target('sbin/start-stop-daemon'), $sh_option )

sh( %{chroot #{$lucie_root} apt-get update}, $sh_option )
begin
  sh( %{chroot #{$lucie_root} apt-get check}, $sh_option )
rescue
  sh( %{chroot #{$lucie_root} apt-get -f -y install </dev/null}, $sh_option )
end
begin
  sh( %{chroot #{$lucie_root} dpkg -C}, $sh_option )
rescue
  sh( %{yes '' | chroot #{$lucie_root} dpkg --configure -a}, $sh_option )
end
sh( %{chroot #{$lucie_root} apt-get -f -y dist-upgrade </dev/null}, $sh_option )
# update dpkg info which packages are available
sh( %{chroot #{$lucie_root} apt-cache dumpavail > #{target('tmp/dumpavail')}}, $sh_option )
sh( %{chroot #{$lucie_root} dpkg --update-avail /tmp/dumpavail}, $sh_option )
rm_f( target('tmp/dumpavail'), $sh_option )

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
