#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'

module Lucie
  module Config
    class Host < Resource
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
      required_attribute :mac_address
      
      # ------------------------- Special accessor behaviours (overwriting default).
      
      REGEXP_PRINTABLE = /\A[ -~]+\z/
      REGEXP_IPADDR = /\A((0|[1-9]\d{0,2})\.){3}(0|[1-9]\d{0,2})\z/ # FIXME: もっと厳密にやる？
#      REGEXP_IPADDR = /\A(0|[1-9]\d{0,2})(\.\1){3}\z/ # 後方参照の使い方間違ってる？
      REGEXP_MACADDR = /\A([0-9A-Fa-f]{2}\:){5}[0-9A-Fa-f]{2}\z/ # FIXME: 区切り文字にコロン以外も認める？
#      REGEXP_MACADDR = /\A([0-9A-Fa-f]{2})(\:\1){5}\z/ # 後方参照の使い方間違ってる？

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
      
      overwrite_accessor :mac_address= do |_mac_address|
        unless (_mac_address.nil?) || ( REGEXP_MACADDR =~ _mac_address)
          raise InvalidAttributeException, "Invalid attribute for mac_address: #{_mac_address}"     
        end
        @mac_address = _mac_address
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: