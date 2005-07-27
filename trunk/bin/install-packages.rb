#!/usr/bin/ruby1.8
#
# $Id$
#
# install-packages スクリプトは選択されたソフトウェアパッケージをイン
# ストールします。/etc/lucie/package ディレクトリ以下のすべての設定ファ
# イルを読み込みます。文法は非常にシンプルです。
#
#   # パッケージ選択設定
#
#   taskinst( %w(german) )
#  
#   aptitude do |aptitude|
#     aptitude.list = %w(adduser netstd ae less passwd)
#   end
# 
#   remove( %w(gpm xdm) )
#  
#   dselect_upgrade do |dselect_upgrade|
#     dselect_upgrade.list << { :package => 'ddd',  :action => 'install' }
#     dselect_upgrade.list << { :package => 'a2ps', :action => 'install' }
#   end
#
# コメントはハッシュ記号 (#) から行末までです。すべてのコマンドは Ruby 
# の関数呼び出し形式となっており、配列やブロックなどの引数を取ります。
# コマンド名は apt-get のコマンドに近いです。以下がサポートしているコ
# マンドの一覧です。
#
# <b>hold:</b> 
#
# パッケージのバージョンを固定します。ホールドされたパッケージは 
# +dpkg+ によってハンドルされなくなります。つまり、アップグレードされ
# なくなります。
#
# <em>例</em>
#  hold( %w(ssh less rsync) )
#
# <b>install:</b>
#
# リストで指定したすべてのパッケージをインストールします。パッケージ名
# の後にハイフンが付けられていた場合 (間に空白は含まない)、そのパッケー
# ジはインストールされず削除されます。
#
# <em>例</em>
#  install do |install|
#    install.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
#    install.list = %w(ssh tcsh cfengine rsync)
#  end
#
# <b>remove:</b>
#
# 引数で指定したすべてのパッケージを削除します。パッケージをインストー
# ルしたい場合には '+' をパッケージ名に続けて記述します。
#
# <em>例</em>
#  remove( %w(rsync jove rstatd) )
#
# <b>taskinst:</b>
#
# 引数で指定したタスクに含まれるすべてのパッケージを tasksel(1) を用い
# てインストールします。タスクのインストールには +aptitude+ を用いるこ
# ともできます。
#
# <em>例</em>
#  taskinst( %w(japanese german) )
#
# <b>aptitude:</b>
#
# すべてのパッケージを +aptitude+ コマンドでインストールする。
#
# <em>例</em>
#  aptitude do |aptitude|
#    aptitude.list = %w(ssh tcsh cfengine rsync)
#  end
#
# <b>aptitude-r:</b>
#
# aptitude コマンドと同様ですが、+aptitude+ を --with-recommends オ
# プション付きで実行します
#
# <em>例</em>
#  aptitude do |aptitude|
#    aptitude.list = %w(ssh tcsh cfengine rsync)
#  end
#
# <b>dselect-upgrade:</b>
#
# パッケージ選択の設定を行います。"dpkg --get-selection" の出力と同様
# に、:package にはパッケージ名、:action には実行したいアクションを指
# 定します。
#
# <em>例</em>
#   dselect_upgrade do |dselect_upgrade|
#     dselect_upgrade.list << { :package => 'ddd',  :action => 'install' }
#     dselect_upgrade.list << { :package => 'a2ps', :action => 'install' }
#   end
#
# すべての依存関係は解決されます。サフィックスに '-' を付けたパッケー
# ジ名はインストールされる代わりに削除されます。パッケージの順序は意味
# を持ちません。
#
# ブロック中で +preloadrm+ を指定した場合、パッケージのインストール前
# に wget(1) を用いたファイルのダウンロードが行われます。file: で指定
# される URL を用いることによって、指定されたファイルは Lucie の ROOT 
# ファイルシステムもしくはインターネット上からダウンロードディレクトリ
# へコピーされます。例として、realplayer パッケージはインストールのた
# めにアーカイブファイルを必要とするため、アーカイブファイルが /root 
# へダウンロードされます。インストールの後このファイルは削除されます。
# ファイルを削除したくない場合には、代わりに +preload+ を使用してくだ
# さい。
#
#--
# TODO: utils/chkdebnames、チェックオプションの移植
# TODO: preload, preloadrm のちゃんとしたサポート
# TODO: hold 引数での文字列サポート
# TODO: install コマンドでの preloadXX のサポート
# TODO: ブロック引数を取らない install 形式のサポート
# TODO: remove 引数での文字列サポート
# TODO: taskinst 引数での文字列サポート
# TODO: ブロック引数を取らない aptitude 形式のサポート 
# TODO: ブロック引数を取らない aptitude-r 形式のサポート 
#++
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2
#

require 'English'
require 'install-packages/abstract-command'
require 'install-packages/app'
require 'install-packages/command/aptitude'
require 'install-packages/command/aptitude-r'
require 'install-packages/command/clean'
require 'install-packages/command/dselect-upgrade'
require 'install-packages/command/hold'
require 'install-packages/command/install'
require 'install-packages/command/remove'
require 'install-packages/command/taskinst'
require 'install-packages/command/taskrm'
require 'install-packages/options'
require 'uri'

if __FILE__ == $PROGRAM_NAME
  InstallPackages::App.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
