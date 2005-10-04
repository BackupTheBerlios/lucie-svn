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
    #
    # インストーラ間の差分と共通部分を定義するためのクラス。
    #
    # <b>インストーラ:</b> +installer_A+, +installer_B+, +installer_C+, ...
    # 
    # があった場合、各インストーラ間の差分 & 共通部分インストーラを以下のように定義できる。
    #
    #  Lucie::Config::DiffInstaller.new do |diff_installer|
    #    diff_installer.name = 'hotswap_node'
    #    diff_installer.installers = [Installer['installer_A'], Installer['installer_B'], ...]
    #  end
    #  
    #  or 
    # 
    #  # 短くしたバージョン
    #  diff_installer do |diff_installer|
    #    diff_installer.name = 'hotswap_node'
    #    diff_installer.installers = [Installer['installer_A'], Installer['installer_B'], ...]
    #  end
    #
    # この場合、共通インストーラとして +hotswap_node+ が明示的に定義さ
    # れる。また、共通インストーラから各インストーラへの差分インストー
    # ラが暗に
    #
    # * +hotswap_node_to_installer_A+, +hotswap_node_to_installerB+, ...
    #
    # という名前で定義される。
    #
    class DiffInstaller < Resource
      # 登録されている DiffInstaller のリスト
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

