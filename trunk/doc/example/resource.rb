# = Lucie サンプル設定
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'lucie/config'
include Lucie::Config

# ------------------------- ホストの定義.

host do |host|
  host.name = 'cluster_node00'
  host.alias = 'Cluster Node #00'
  host.address = '192.168.0.1'
  host.mac_address = '00:0C:29:41:88:F0'
end

host do |host|
  host.name = 'cluster_node01'
  host.alias = 'Cluster Node #01'
  host.address = '192.168.0.2'
  host.mac_address = '00:0C:29:41:88:F1'
end

host do |host|
  host.name = 'cluster_node02'
  host.alias = 'Cluster Node #02'
  host.address = '192.168.0.3'
  host.mac_address = '00:0C:29:41:88:F2'
end

# ------------------------- ホストグループの定義.

host_group do |group|
  group.name = 'presto_cluster'
  group.alias = 'Presto Cluster'
  group.members = [Host['cluster_node00'], Host['cluster_node01'], Host['cluster_node02']]    
end

# ------------------------- パッケージサーバの定義.

package_server do |pkgserver|
  pkgserver.name         = 'debian_mirror'
  pkgserver.alias       = 'Local Debian Repository Mirror'
  pkgserver.uri          = 'http://192.168.1.100/debian/'
end

# ------------------------- DHCP サーバの定義.

dhcp_server do |dhcp_server|
  dhcp_server.name            = 'dhcp'
  dhcp_server.alias          = 'Cluster DHCP Server'
  dhcp_server.nis_domain_name = 'yp.titech.ac.jp'
  dhcp_server.gateway         = '192.168.1.254'
  dhcp_server.address         = '192.168.1.200'
  dhcp_server.subnet          = '255.255.255.0'
  dhcp_server.dns             = '131.112.35.1'
  dhcp_server.domain_name     = 'is.titech.ac.jp'
end

# ------------------------- インストーラの定義.

installer do |installer|
  installer.name                 = 'presto_installer'
  installer.alias               = 'Presto Cluster Installer'
  installer.address              = '192.168.1.200'
  installer.host_group           = HostGroup['presto_cluster']
  installer.package_server       = PackageServer['debian_mirror']
  installer.dhcp_server          = DHCPServer['dhcp']
  installer.kernel_version       = '2.2.18'
  installer.kernel_package       = 'kernel-image-2.4.27_lucie20040923_i386.deb'  
  installer.root_password        = 'xxxxxxxx'
  installer.distribution         = 'debian'
  installer.distribution_version = 'woody'
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
