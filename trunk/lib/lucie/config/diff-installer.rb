#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'
require 'lucie/time-stamp'

module Lucie
  update(%q$Id$)

  module Config
    class DiffInstaller < Resource
      # 登録されている Host のリスト
      @@list = {}

      # アトリビュート名のリスト: [:name, :version, ...]
      @@required_attributes = []
      
      # _すべての_ アトリビュート名とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # アトリビュート名からデフォルト値へのマッピング
      @@default_value = {}

      required_attribute :name
      required_attribute :installers
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:

