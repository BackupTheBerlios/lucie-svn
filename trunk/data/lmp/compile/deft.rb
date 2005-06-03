#
# $Id$
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/compile/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-compile setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup packages for developing software.
  DESCRIPTION
  template.short_description_ja = 'lmp-compile セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは開発用ソフトウェアの設定を Lucie サーバへ行います。
  このメタパッケージによってクラスタノードにインストールされるパッケージの一覧は以下の通りです。

   o electric-fence: malloc(3) デバッガ
   o bin86: 16 ビットのアセンブラとローダ
   o m4: マクロ処理言語
   o g77: GNU Fortran 77コンパイラ
   o byacc: The Berkeley LALR parser generator
   o cvs: 共同作業可能なバージョン管理システム
   o ddd: Data Display Debugger - グラフィカルなデバッガフロントエンド
   o indent: C 言語ソースコード整形プログラム
   o autoconf: configure スクリプト自動生成ツール
   o automake1.8: A tool for generating GNU Standards-compliant Makefiles
   o binutils: GNU アセンブラ、リンカ、バイナリユーティリティ
   o bison: yacc と互換性のあるパーサジェネレータ
   o flex: 高速な構文解析器生成プログラム
   o cpp: GNU C プリプロセッサ
   o cutils: C ソースコード用ユーティリティ集
   o cxref: C プログラム用の LaTex や HTML ドキュメント生成プログラム
   o g++: GNU C++ コンパイラ
   o gcc: GNU Cコンパイラ
   o gdb: GNU デバッガ
   o glibc-doc: GNU C ライブラリドキュメント
   o libtool: 汎用のライブラリサポートスクリプト
   o ltrace: プログラムに動的にリンクされるランタイムライブラリコールを追跡
   o make: GNU バージョンの "make" ユーティリティ
   o manpages-dev: GNU/Linux 開発者向けのマニュアルページ
   o patch: diff ファイルをオリジナルのファイルに適用する
   o stl-manual: C++ 言語の STL ライブラリについての HTML ドキュメント
   o strace: システムコール追跡ツール
  DESCRIPTION_JA
end

question( 'lucie-client/compile/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
