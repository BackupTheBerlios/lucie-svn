#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

sh( %{echo 6 > /proc/sys/kernel/printk}, $sh_option )
sh( %{klogd -c7 -f #{$kernel_log}}, $sh_option )
sh( %{syslogd -m 0 -p /tmp/etc/syslogsocket}, $sh_option )

# create_resolv_conf
sh( %{echo "domain #{dhcp_server_resource.domain_name}" >/tmp/etc/resolv.conf}, $sh_option )
# TODO: primary/secondary dns サーバへの対応
sh( %{echo "nameserver #{dhcp_server_resource.dns}"    >>/tmp/etc/resolv.conf}, $sh_option )

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
