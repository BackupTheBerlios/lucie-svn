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
      required_attribute :name
      required_attribute :alias
      required_attribute :address
      required_attribute :mac_address
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: