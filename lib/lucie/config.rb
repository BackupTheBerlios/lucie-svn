# = Lucie ���\�[�X�ݒ�t�@�C���p���C�u����
#
# Lucie ���\�[�X�ݒ�t�@�C�� <code>/etc/lucie/resource.rb</code> �̐擪�ł��̃t�@�C����
# <code>require</code> ���邱�ƁB�ڂ����� <code>doc/example/resource.rb</code> ���Q�ƁB
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

# ------------------------- Convenience methods.

# dhcp_server ���\�[�X�̒�`�p
def dhcp_server( &block )
  return Lucie::Config::DHCPServer.new( &block )
end

# host ���\�[�X�̒�`�p
def host( &block )
  return Lucie::Config::Host.new( &block )
end

# host_group ���\�[�X�̒�`�p
def host_group( &block )
  return Lucie::Config::HostGroup.new( &block )
end

# installer ���\�[�X�̒�`�p
def installer( &block )
  return Lucie::Config::Installer.new( &block )
end

# package_server ���\�[�X�̒�`�p
def package_server( &block )
  return Lucie::Config::PackageServer.new( &block )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
