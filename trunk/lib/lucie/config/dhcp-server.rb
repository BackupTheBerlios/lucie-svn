#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'

module Lucie
  module Config
    class DHCPServer < Resource
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
      required_attribute :nis_domain_name
      required_attribute :gateway
      required_attribute :address
      required_attribute :subnet
      required_attribute :dns
      required_attribute :domain_name

      public
      def network
        address_ary = @address.split('.').collect { |octet|
          octet.to_i 
        }
        subnet_ary = @subnet.split('.').collect { |octet|
          octet.to_i 
        }
        ((address_ary[0] & subnet_ary[0]) & 0xff).to_s + '.' + \
        ((address_ary[1] & subnet_ary[1]) & 0xff).to_s + '.' + \
        ((address_ary[2] & subnet_ary[2]) & 0xff).to_s + '.' + \
        ((address_ary[3] & subnet_ary[3]) & 0xff).to_s
      end

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

      overwrite_accessor :nis_domain_name= do |_nis_domain_name|
        unless (_nis_domain_name.nil?) || ( /\A[\w\-_.]+\Z/ =~ _nis_domain_name)
          raise InvalidAttributeException, "Invalid attribute for nis_domain_name: #{_nis_domain_name}"
        end
        @nis_domain_name = _nis_domain_name
      end

      overwrite_accessor :gateway= do |_gateway|
        unless (_gateway.nil?) || ( REGEXP_IPADDR =~ _gateway)
          raise InvalidAttributeException, "Invalid attribute for gateway: #{_gateway}"     
        end
        @gateway = _gateway
      end 

      overwrite_accessor :address= do |_address|
        unless (_address.nil?) || ( REGEXP_IPADDR =~ _address)
          raise InvalidAttributeException, "Invalid attribute for address: #{_address}"     
        end
        @address = _address
      end 

      overwrite_accessor :subnet= do |_subnet|
        unless (_subnet.nil?) || ( REGEXP_IPADDR =~ _subnet)
          raise InvalidAttributeException, "Invalid attribute for subnet: #{_subnet}"     
        end
        @subnet = _subnet
      end 

      overwrite_accessor :dns= do |_dns|
        unless (_dns.nil?) || ( REGEXP_IPADDR =~ _dns)
          raise InvalidAttributeException, "Invalid attribute for dns: #{_dns}"     
        end
        @dns = _dns
      end 

      overwrite_accessor :domain_name= do |_domain_name|
        unless (_domain_name.nil?) || ( /\A[\w\-_.]+\z/ =~ _domain_name)
          raise InvalidAttributeException, "Invalid attribute for domain_name: #{_domain_name}"
        end
        @domain_name = _domain_name
      end

    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: