#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'

module Lucie
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
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: