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