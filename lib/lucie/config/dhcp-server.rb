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
      required_attribute :name
      required_attribute :alias
      required_attribute :nis_domain_name
      required_attribute :gateway
      required_attribute :address
      required_attribute :subnet
      required_attribute :dns
      required_attribute :domain_name
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: