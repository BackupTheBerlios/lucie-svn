# = Lucie �꥽��������ե������ѥ饤�֥��
#
# Lucie �꥽��������ե����� <code>/etc/lucie/resource.rb</code> ����Ƭ�Ǥ��Υե������
# <code>require</code> ���뤳�ȡ��ܤ����� <code>doc/example/resource.rb</code> �򻲾ȡ�
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

# dhcp_server �꥽�����������
def dhcp_server( &block )
  return Lucie::Config::DHCPServer.new( &block )
end

# host �꥽�����������
def host( &block )
  return Lucie::Config::Host.new( &block )
end

# host_group �꥽�����������
def host_group( &block )
  return Lucie::Config::HostGroup.new( &block )
end

# installer �꥽�����������
def installer( &block )
  return Lucie::Config::Installer.new( &block )
end

# package_server �꥽�����������
def package_server( &block )
  return Lucie::Config::PackageServer.new( &block )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
