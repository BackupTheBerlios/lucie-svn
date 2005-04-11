#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

# FIXME: 正規表現は可読性とメンテナンス性のためあとで変数などにくくり出す。resouce.rb あたりでまとめる？

require 'lucie/config/resource'

module Lucie
  update(%q$Date$)

  module Config
    class Installer < Resource
      # 登録されている Host のリスト
      @@list = {}
      
      # アトリビュート名のリスト: [:name, :version, ...]
      @@required_attributes = []
      
      # _すべての_ アトリビュート名とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # アトリビュート名からデフォルト値へのマッピング
      @@default_value = {}
      
      required_attribute :name
      required_attribute :alias
      required_attribute :address
      required_attribute :package_server
      required_attribute :kernel_version
      required_attribute :kernel_package
      required_attribute :dhcp_server
      required_attribute :root_password
      required_attribute :host_group
      required_attribute :distribution
      required_attribute :distribution_version
      
      # ------------------------- Special accessor behaviours (overwriting default).

      REGEXP_PRINTABLE = /\A[ -~]+\z/
      REGEXP_IPADDR = /\A((0|[1-9]\d{0,2})\.){3}(0|[1-9]\d{0,2})\z/ # FIXME: もっと厳密にやる？
#      REGEXP_IPADDR = /\A(0|[1-9]\d{0,2})(\.\1){3}\z/ # 後方参照の使い方間違ってる？
      
      overwrite_accessor :name= do |_name|
        unless (_name.nil?) || ( /\A[\w\-_]+\z/ =~ _name)
          raise InvalidAttributeException, "Invalid attribute for name: #{_name}"
        end
        @name = _name
      end
      
      overwrite_accessor :alias= do |_alias|
        unless (_alias.nil?) || ( REGEXP_PRINTABLE =~ _alias)
          raise InvalidAttributeException, "Invalid attribute for alias: #{_alias}"
        end
        @alias = _alias
      end
      
      overwrite_accessor :address= do |_address|
        unless (_address.nil?) || ( REGEXP_IPADDR =~ _address)
          raise InvalidAttributeException, "Invalid attribute for address: #{_address}"     
        end
        @address = _address
      end 
      
      overwrite_accessor :package_server= do |_package_server|
        unless (_package_server.nil?) || (_package_server.instance_of?(Lucie::Config::PackageServer))
          raise InvalidAttributeException, "Invalid attribute for package_server: #{_package_server}"     
        end
        @package_server = _package_server
      end
      
      overwrite_accessor :kernel_version= do |_kernel_version|
        unless (_kernel_version.nil?) || ( /\A\d+[\w\d\.\-]*\z/ =~ _kernel_version)
        # FIXME: 数字とピリオドの組み合わせ以外もある？
          raise InvalidAttributeException, "Invalid attribute for kernel_version: #{_kernel_version}"
        end
        @kernel_version = _kernel_version
      end

      overwrite_accessor :kernel_package= do |_kernel_package|
        unless (_kernel_package.nil?) || ( /kernel-image-.*\.deb\z/ =~ _kernel_package)
        # FIXME: kernel のパッケージ命名規則要確認。rpm もサポート？
          raise InvalidAttributeException, "Invalid attribute for kernel_package: #{_kernel_package}"
        end
        @kernel_package = _kernel_package
      end

      overwrite_accessor :dhcp_server= do |_dhcp_server|
        unless (_dhcp_server.nil?) || (_dhcp_server.instance_of?(Lucie::Config::DHCPServer))
          raise InvalidAttributeException, "Invalid attribute for dhcp_server: #{_dhcp_server}"     
        end
        @dhcp_server = _dhcp_server
      end

      overwrite_accessor :root_password= do |_root_password|
        unless (_root_password.nil?) || ( REGEXP_PRINTABLE =~ _root_password)
          raise InvalidAttributeException, "Invalid attribute for root_password: #{_root_password}"
        end
        @root_password = _root_password
      end

      overwrite_accessor :host_group= do |_host_group|
        unless (_host_group.nil?) || (_host_group.instance_of?(Lucie::Config::HostGroup))
          raise InvalidAttributeException, "Invalid attribute for host_group: #{_host_group}"     
        end
        @host_group = _host_group
      end

      overwrite_accessor :distribution= do |_distribution|
        unless (_distribution.nil?) || ( /\A([Dd][Ee][Bb][Ii][Aa][Nn]|[Rr][Ee][Dd][Hh][Aa][Tt])\Z/ =~ _distribution)
          raise InvalidAttributeException, "Invalid attribute for distribution: #{_distribution}"
        end
        @distribution = _distribution
      end

      overwrite_accessor :distribution_version= do |_distribution_version|
        unless (_distribution_version.nil?) || ( /\A(woody|sarge)\Z/ =~ _distribution_version)
          # FIXME: サポートするバージョンをすべてくくり出す？ or [\w\-_]+ くらいにしておく？
          raise InvalidAttributeException, "Invalid attribute for distribution_version: #{_distribution_version}"
        end
        @distribution_version = _distribution_version
      end
     end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
