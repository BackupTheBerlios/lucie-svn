#!/usr/bin/ruby1.8
#
# $Id$
#
# install-packages スクリプトは選択されたソフトウェアパッケージをイン
# ストールします。/etc/lucie/package ディレクトリ以下のすべての設定ファ
# イルを読み込みます。文法は非常にシンプルです。
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
# hold: 
#     パッケージのバージョンを固定します。ホールドされたパッケージは 
#     dpkg による操作ができなくなります。つまり、アップグレードされな
#     くなります。
#
# install:
#     リストで指定したすべてのパッケージをインストールします。パッケー
#     ジ名の後にハイフンが付けられていた場合 (空白は含まない)、そのパッ
#     ケージはインストールされず削除されます。
#
# remove:
#     引数で指定したすべてのパッケージを削除します。パッケージをインス
#     トールしたい場合には '+' をパッケージ名に続けて記述します。
#
# taskinst:
#     引数で指定したタスクに含まれるすべてのパッケージを tasksel(1) を
#     用いてインストールする。タククのインストールには aptitude を用い
#     ることもできる。
#
# aptitude:
#     すべてのパッケージを aptitude コマンドでインストールする。
#
# aptitude-r:
#     aptitude コマンドと同様だが、aptitude を --with-recommends オプ
#     ション付きで実行する。
#
# dselect-upgrade:
#     パッケージ選択の設定を行います。"dpkg --get-selection" の出力と
#     同様に、:package にはパッケージ名、:action には実行したいアクショ
#     ンを指定します。
#
# すべての依存関係は解決されます。サフィックスに '-' を付けたパッケー
# ジ名はインストールされる代わりに削除されます。パッケージの順序は意味
# を持ちません。
#
# ブロック中で preloadrm を指定した場合、パッケージのインストール前に 
# wget(1) を用いたファイルのダウンロードが行われます。file: で指定され
# る URL を用いることによって、指定されたファイルは Lucie の ROOT ファ
# イルシステムもしくはインターネット上からダウンロードディレクトリへコ
# ピーされます。例として、realplayer パッケージはインストールのために
# アーカイブファイルを必要とするため、アーカイブファイルが /root へダ
# ウンロードされます。インストールの後このファイルは削除されます。ファ
# イルを削除したくない場合には、代わりに preload を使用してください。
#
#--
# TODO: utils/chkdebnames、チェックオプションの移植
# TODO: preload, preloadrm のちゃんとしたサポート
# TODO: それぞれのコマンドの記述例
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
