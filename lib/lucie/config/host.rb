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
      
      overwrite_accessor :name= do |name|
        unless (name.nil?) or ( /\A[\w\-_]+\Z/=~ name)
          raise InvalidAttributeException, "Invalid attribute for name: #{name}"
        end
        @name = name
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: