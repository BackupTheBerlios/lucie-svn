#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Rake
  # インストーラのベースシステムをビルドするタスクを作成する。
  #
  # InstallerBaseTask は次のターゲットを作成する:
  #
  # [<b><em>installer_base</em></b>]
  #   InstallerBase タスクのメインタスク
  # [<b><em>:clobber_installer_base</em></b>]
  #   すべてのインストーラベース関連ファイルを消去する。
  #   このターゲットは自動的にメインの clobber ターゲットに追加される
  # [<b><em>:reinstaller_base</em></b>]
  #   タイムスタンプに関わらずインストーラベースをまっさらからリビルドする
  #
  # 例:
  #
  #   InstallerBaseTask.new do |installer_base|
  #     installer_base.directory = "tmp"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "sarge"
  #   end
  #
  # 作成する InstallerBaseTask にはデフォルトの名前以外に自分の好きな名前を
  # つけることもできる。
  #
  #   InstallerBaseTask.new(:installer_base_woody) do |installer_base|
  #     installer_base.directory = "tmp"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "woody"
  #   end
  # 
  # この場合、<em>:installer_base_woody</em>, :clobber_<em>installer_base_woody</em>, 
  # :re<em>installer_base_woody</em> という名前のタスクが生成される。
  #
  class InstallerBaseTask
    # インストーラベース作成タスクの名前 (デフォルト: :installer_base )
    attr_accessor :name
    # インストーラベースを作成するディレクトリへのパス 
    # (デフォルト: '/var/lib/lucie/installer-base/' )
    attr_accessor :directory
    # インストーラベースのディストリビューション (デフォルト: nil)
    attr_accessor :distribution
    # インストーラベースのディストリビューションのバージョン (デフォルト: nil)
    attr_accessor :distribution_version
    
    # InstallerBase タスクを作成する。デフォルトの名前は +installer_base+
    public
    def initialize( name=:installer_base ) # :yield: self
      @name = name
      @directory = '/var/lib/lucie/installer-base/'
      yield self if block_given?
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: