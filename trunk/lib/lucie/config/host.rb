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
      # �o�^����Ă��� Host �̃��X�g
      @@list = {}
      
      # �A�g���r���[�g���̃��X�g: [:name, :version, ...]
      @@required_attributes = []
      
      # _���ׂĂ�_ �A�g���r���[�g���ƃf�t�H���g�l�̃��X�g: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # �A�g���r���[�g������f�t�H���g�l�ւ̃}�b�s���O
      @@default_value = {}
      
      required_attribute :name
      required_attribute :alias
      required_attribute :address
      required_attribute :mac_address
      
      # ------------------------- Special accessor behaviours (overwriting default).
      
      REGEXP_PRINTABLE = /\A[ -~]+\z/
      REGEXP_IPADDR = /\A((0|[1-9]\d{0,2})\.){3}(0|[1-9]\d{0,2})\z/ # FIXME: �����ƌ����ɂ��H
#      REGEXP_IPADDR = /\A(0|[1-9]\d{0,2})(\.\1){3}\z/ # ����Q�Ƃ̎g�����Ԉ���Ă�H
      REGEXP_MACADDR = /\A([0-9A-Fa-f]{2}\:){5}[0-9A-Fa-f]{2}\z/ # FIXME: ��؂蕶���ɃR�����ȊO���F�߂�H
#      REGEXP_MACADDR = /\A([0-9A-Fa-f]{2})(\:\1){5}\z/ # ����Q�Ƃ̎g�����Ԉ���Ă�H

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