# = Lucie リソース設定ファイル用ライブラリ
#
# Lucie リソース設定ファイル <code>/etc/lucie/resource.rb</code> の先頭でこのファイルを
# <code>require</code> すること。詳しくは <code>doc/example/resource.rb</code> を参照。
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'lucie/config/dhcp-server'
require 'lucie/config/host'
require 'lucie/config/host-group'
require 'lucie/config/installer'
require 'lucie/config/package-server'
require 'lucie/time-stamp'

Lucie::update(%q$Id$)

# ------------------------- Convenience methods.

# dhcp_server リソースの定義用
def dhcp_server( &block )
  return Lucie::Config::DHCPServer.new( &block )
end

# host リソースの定義用
def host( &block )
  return Lucie::Config::Host.new( &block )
end

# host_group リソースの定義用
def host_group( &block )
  return Lucie::Config::HostGroup.new( &block )
end

# installer リソースの定義用
def installer( &block )
  return Lucie::Config::Installer.new( &block )
end

# package_server リソースの定義用
def package_server( &block )
  return Lucie::Config::PackageServer.new( &block )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
