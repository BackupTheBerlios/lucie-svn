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
  This metapackage will generate Lucie configuration of installing development software packages.
  Packages installed with this metapackage are follows:

   o electric-fence: A malloc(3) debugger
   o bin86: 16-bit x86 assembler and loader
   o m4: a macro processing language
   o g77: The GNU Fortran 77 compiler
   o byacc: The Berkeley LALR parser generator
   o cvs: Concurrent Versions System
   o ddd: The Data Display Debugger, a graphical debugger frontend
   o indent: C language source code formatting program
   o autoconf: automatic configure script builder
   o automake1.8: A tool for generating GNU Standards-compliant Makefiles
   o binutils: The GNU assembler, linker and binary utilities
   o bison: A parser generator that is compatible with YACC
   o flex: A fast lexical analyzer generator
   o cpp: The GNU C preprocessor (cpp)
   o cutils: C source code utilities
   o cxref: Generates latex and HTML documentation for C programs
   o g++: The GNU C++ compiler
   o gcc: The GNU C compiler
   o gdb: The GNU Debugger
   o glibc-doc: GNU C Library: Documentation
   o libtool: Generic library support script
   o ltrace: Tracks runtime library calls in dynamically linked programs
   o make: The GNU version of the "make" utility.
   o manpages-dev: Manual pages about using GNU/Linux for development
   o patch: Apply a diff file to an original
   o stl-manual: C++-STL documentation in HTML
   o strace: A system call tracer
  DESCRIPTION
  template.short_description_ja = 'lmp-compile セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは C や C++ 関連の開発用ソフトウェアの設定を Lucie サーバへ行います。
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

question( 'lucie-client/compile/hello' => 'lucie-client/compile/configuration-level' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- 設定方法の選択

template( 'lucie-client/compile/configuration-level' ) do |template|
  template.template_type = 'select'
  template.choices = ['basic', 'custom']
  template.short_description = 'Choose configuration level'
  template.extended_description = <<-DESCRIPTION
  Choose configuration level.
  With "basic" configuration, you can select a predefined set of compilers with the same version number.
  This is for beginners.
  With "custom" configuration, you can individually specify versions to use for each C/C++ compilers.
  This is advanced option.
  DESCRIPTION
  template.short_description_ja = '設定方法の選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定オプションを選んでください。
  「basic」設定では C や C++ コンパイラのバージョンを一括して設定します。
  よくわからない場合はこちらを選択してください。
  「custom」設定ではコンパイラ別に設定を行います。上級者向けです。
  DESCRIPTION_JA
end

question( 'lucie-client/compile/configuration-level' => 
          { 'basic' => 'lucie-client/compile/basic', 'custom' => 'lucie-client/compile/g77' } ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- basic 設定

template( 'lucie-client/compile/basic' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = "Choose compilers' version"
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default Fortran/CPP/C++/C compilers?
  Compilers of the version specified at this question are installed to cluster nodes.
  DESCRIPTION
  template.short_description_ja = 'コンパイラバージョンの選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトとしてコンパイラのどのバージョンを使いますか ?
  ここで指定されたバージョンの g77, cpp, g++, gcc がクラスタノードにインストールされます。
  DESCRIPTION_JA
end

question( 'lucie-client/compile/basic' => 
          proc do |user_input|
            set 'lucie-client/compile/g77', user_input
            set 'lucie-client/compile/cpp', user_input
            set 'lucie-client/compile/gpp', user_input
            set 'lucie-client/compile/gcc', user_input
          end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- g77 のバージョン選択

template( 'lucie-client/compile/g77' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default g77 version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default g77 compiler?
  DESCRIPTION
  template.short_description_ja = 'デフォルト g77 バージョンの選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトとして g77 コンパイラのどのバージョンを使いますか ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/g77' => 'lucie-client/compile/cpp' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- cpp のバージョン選択

template( 'lucie-client/compile/cpp' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default cpp version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default cpp compiler?
  DESCRIPTION
  template.short_description_ja = 'デフォルト cpp バージョンの選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトとして cpp コンパイラのどのバージョンを使いますか ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/cpp' => 'lucie-client/compile/gpp' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- g++ のバージョン選択

template( 'lucie-client/compile/gpp' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default g++ version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default g++ compiler?
  DESCRIPTION
  template.short_description_ja = 'デフォルト g++ バージョンの選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトとして g++ コンパイラのどのバージョンを使いますか ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/gpp' => 'lucie-client/compile/gcc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- gcc のバージョン選択

template( 'lucie-client/compile/gcc' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default gcc version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default gcc compiler?
  DESCRIPTION
  template.short_description_ja = 'デフォルト gcc バージョンの選択'
  template.extended_description_ja = <<-DESCRIPTION_JA
  デフォルトとして gcc コンパイラのどのバージョンを使いますか ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/gcc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
