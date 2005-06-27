# =libdepends メインファイル
#
# libdepends のメインファイル。libdepends を使用する場合にはこのファイ
# ルを以下のように +require+ すること。
#
#  require 'depends'
#
# $Id$
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision$
# License::  GPL2
#
#--
# TODO:
# * Support RPM and other formats.
#++

module Depends
  # バージョン番号
  VERSION = '0.0.2'.freeze
  # 使用できるパッケージ状態
  STATUS  = '/var/lib/dpkg/status'.freeze
end

require 'depends/cache'
require 'depends/dependency'
require 'depends/package'
require 'depends/pool'

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
