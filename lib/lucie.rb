# = Lucie ライブラリのメインファイル
#
# LMP 設定ファイルの頭では本ファイル (lucie.rb) をかならず require し、
# template, question などのトップレベル関数を読み込むこと。
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/template'
require 'lucie/note-template'
require 'lucie/string-template'
require 'lucie/boolean-template'
require 'lucie/select-template'
require 'lucie/multiselect-template'

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: