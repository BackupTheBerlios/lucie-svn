#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'

include Deft

# ------------------------- エラー表示用テンプレート/質問 

template( 'lucie-vmsetup/error' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '${short_error_message}'
  template.extended_description_ja = '${extended_error_message}'
end

question( 'lucie-vmsetup/error-backup' ) do |question|
  question.template = Template['lucie-vmsetup/error']
  question.priority = Question::PRIORITY_MEDIUM
  question.backup = true
end

question( 'lucie-vmsetup/error-abort' ) do |question|
  question.template = Template['lucie-vmsetup/error']
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = nil
end

# ------------------------- 

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このウィザードでは、Lucie を用いた VM セットアップの設定を入力します。
  設定可能な項目は、
   o 必要な VM の台数
   o 外部ネットワークへの接続
   o VM で使用するメモリ容量
   o VM で使用するハードディスク容量
   o 使用する VM の種類
   o VM へインストールする Linux ディストリビューションの種類
   o VM へインストールするソフトウェアの種類
  です。自分が VM 上で走らせたいジョブの特性によって設定を決めてください。

  「次へ」をクリックするとウィザードを開始します。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vmpool-server-ip'
  question.first_question = true
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-ip' ) do |template|
  template.template_type = 'string'
  template.default = '127.0.0.1'
  template.short_description_ja = 'Lucie VM Pool サーバの IP アドレス'
  template.extended_description_ja = 'Lucie VM Pool サーバの IP アドレスを入力してください'
end

question( 'lucie-vmsetup/vmpool-server-ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    unless /\\A\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}\\Z/=~ user_input
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: IP アドレス形式"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "IP アドレスの形式が正しくありません : \#{get('lucie-vmsetup/vmpool-server-ip')}"
      'lucie-vmsetup/error-backup'
    else
      subst 'lucie-vmsetup/vmpool-server-confirmation', 'vmpool-server-ip', user_input 
      'lucie-vmsetup/vmpool-server-port'
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-port' ) do |template|
  template.template_type = 'string'
  template.default = '5555'	
  template.short_description_ja = 'Lucie VM Pool サーバのポート番号'
  template.extended_description_ja = 'Lucie VM Pool サーバのポート番号を入力してください'
end

question( 'lucie-vmsetup/vmpool-server-port' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    unless /\\A\\d+\\Z/=~ user_input
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: ポート番号形式"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "ポート番号の形式が正しくありません : \#{get('lucie-vmsetup/vmpool-server-port')}"
      'lucie-vmsetup/error-backup'
    else
      subst 'lucie-vmsetup/vmpool-server-confirmation', 'vmpool-server-port', user_input 
      'lucie-vmsetup/vmpool-server-confirmation'
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-reconnection' ) do |template|
  template.template_type = 'boolean'
  template.short_description_ja = 'Lucie VM Pool サーバへ再接続'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Lucie VM Pool サーバへの接続に失敗しました。
   o IP アドレス ${vmpool-server-ip}
   o ポート番号 ${vmpool-server-port}
  再接続しますか？
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vmpool-server-reconnection' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    case user_input
    when 'true'
      require 'socket'
      require 'lucie-vm-pool/client'
      begin
        socket = TCPSocket.open( get('lucie-vmsetup/vmpool-server-ip'), get('lucie-vmsetup/vmpool-server-port') )
        'lucie-vmsetup/num-nodes'
      rescue 
        'lucie-vmsetup/vmpool-server-reconnection'	
      end
    when 'false'
      subst 'lucie-vmsetup/error-abort', 'short_error_message', 'Lucie VM Pool セットアップの中止'
      subst 'lucie-vmsetup/error-abort', 'extended_error_message', 'Lucie VM Pool のセットアップを中止します'
      'lucie-vmsetup/error-abort'
    end
  end 
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'Lucie VM Pool 情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  次の設定で Lucie VM Pool サーバに接続します
   o IP アドレス ${vmpool-server-ip}
   o ポート番号 ${vmpool-server-port}
  「Next」 を押すと接続します。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vmpool-server-confirmation' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do 
    require 'socket'
    require 'lucie-vm-pool/client'
    begin
      socket = TCPSocket.open( get('lucie-vmsetup/vmpool-server-ip'), get('lucie-vmsetup/vmpool-server-port') )
      $num_nodes_upperbound = LucieVmPool::Client.get( socket, '#nodes upperbound' ).to_i
      subst 'lucie-vmsetup/num-nodes', 'num-nodes', $num_nodes_upperbound
      $memory_size_upperbound = LucieVmPool::Client.get( socket, 'memory size upperbound' ).to_i
      subst 'lucie-vmsetup/memory-size', 'memory-size', $memory_size_upperbound
      $harddisk_size_upperbound	= LucieVmPool::Client.get( socket, 'hdd size upperbound' ).to_i
      subst 'lucie-vmsetup/harddisk-size', 'harddisk-size', $harddisk_size_upperbound
      subst 'lucie-vmsetup/vm-type', 'vm-type', LucieVmPool::Client.get( socket, 'vm' )
      subst 'lucie-vmsetup/distro', 'distro', LucieVmPool::Client.get( socket, 'distro' )
      'lucie-vmsetup/num-nodes'
    rescue 
      'lucie-vmsetup/vmpool-server-reconnection'	
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = 'string'
  template.default = '1'
  template.short_description_ja = 'VM ノードの台数'
  template.extended_description_ja = <<-DESCRIPTION_JA
  使用したい VM の台数を選択してください。

  松岡研 PrestoIII クラスタで提供できる VM クラスタのノード数は、${num-nodes}台までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要な台数を選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードの台数"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードの台数がセットされていません。"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $num_nodes_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードの台数"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードの台数が上限の \#{$num_nodes_upperbound} 台を越えています。"
      'lucie-vmsetup/error-backup'
    else
      subst 'lucie-vmsetup/confirmation', 'num_nodes', user_input
      'lucie-vmsetup/use-network'
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = 'boolean'
  template.default = 'false'
  template.short_description_ja = 'VM の外部ネットワークへの接続'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ジョブ実行時に VM は外部ネットワークへ接続する必要がありますか？
  このオプションをオンにすると、GRAM が自動的に各 VM に連続した IP アドレスと MAC アドレスを割り当て、
  Lucie をすべてのネットワーク関係の設定を行います。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    subst 'lucie-vmsetup/confirmation', 'use_network', user_input
    { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }[user_input]
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'VM の IP アドレス'
  template.extended_description_ja = <<-DESCRIPTION_JA
  以下のようにホスト名、IP アドレス、MAC アドレスを割り振りました。
  使用可能な VM は pad000 - pad003 の 4 ノードです。
  
   ホスト名: pad000
   IP アドレス: 168.220.98.30
   MAC アドレス: 00:50:56:01:02:02

   ホスト名: pad001
   IP アドレス: 163.220.98.31
   MAC アドレス: 00:50:56:01:02:03

   ホスト名: pad002
   IP アドレス: 163.220.98.32
   MAC アドレス: 00:50:56:01:02:04

   ホスト名: pad003
   IP アドレス: 163.220.98.33
   MAC アドレス: 00:50:56:01:02:05
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

# ------------------------- 

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'VM ノードのメモリサイズ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  使用したい VM 一台あたりのメモリサイズを選択してください。単位は MB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのメモリサイズは ${memory-size}MB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なメモリサイズを選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードのメモリサイズ"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードのメモリサイズがセットされていません。"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $memory_size_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードのメモリサイズ"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードのメモリサイズが上限の \#{$memory_size_upperbound} MB を越えています。"
      'lucie-vmsetup/error-backup'
    else
      subst 'lucie-vmsetup/confirmation', 'memory_size', user_input
      'lucie-vmsetup/harddisk-size'
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'VM ノードのハードディスク容量'  
  template.extended_description_ja = <<-DESCRIPTION_JA
  使用したい VM 一台あたりのハードディスク容量を選択してください。単位は GB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのハードディスク容量は ${harddisk-size}GB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なハードディスク容量を選択してください。
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードのハードディスク容量"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードのハードディスク容量がセットされていません。"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $harddisk_size_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "エラー: VM ノードのハードディスク容量"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM ノードのハードディスク容量が上限の \#{$harddisk_size_upperbound} GB を越えています。"
      'lucie-vmsetup/error-backup'
    else
      subst 'lucie-vmsetup/confirmation', 'harddisk_size', user_input	
      'lucie-vmsetup/vm-type'
    end
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = 'select'
  template.choices = '${vm-type}'
  template.short_description_ja = '使用する VM の種類'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ジョブ実行に使用する VM 実装の種類を選択してください
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    subst 'lucie-vmsetup/confirmation', 'vm_type', user_input	
    'lucie-vmsetup/distro'
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = 'select'
  template.choices = '${distro}'
  template.short_description_ja = '使用するディストリビューション'
  template.extended_description_ja = <<-DESCRIPTION_JA
  VM にインストールして使用する Linux ディストリビューションを選択してください
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    subst 'lucie-vmsetup/confirmation', 'distro', user_input	    	
    'lucie-vmsetup/application'
  end
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/application' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = '使用するアプリケーション'
  template.extended_description_ja = <<-DESCRIPTION_JA
  VM にインストールして使用するソフトウェアパッケージを入力してください

  松岡研 PrestoIII クラスタでデフォルトでインストールされるソフトウェアパッケージは以下の通りです。
   o 基本パッケージ: fileutils, findutils などの基本的なユーティリティ
   o シェル: tcsh, bash, zsh などのシェル
   o ネットワークデーモン: ssh や rsh, ftp などのデーモン
  上記に追加してインストールしたいパッケージをコンマ区切りで入力してください。
  
  例: ruby, python, blast2
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    subst 'lucie-vmsetup/confirmation', 'application', user_input	    	
    'lucie-vmsetup/confirmation'
  end
  NEXT_QUESTION
end

# ------------------------- 設定情報の確認

template( 'lucie-vmsetup/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '設定情報の確認'
  template.extended_description_ja = <<-DESCRIPTION_JA
  設定情報を確認します。
   o 使用する VM 台数 : ${num_nodes}台
   o ネットワークへの接続 : ${use_network}
   o メモリサイズ : ${memory_size}MB
   o ハードディスクサイズ : ${harddisk_size}GB
   o VM の種類 : ${vm_type}
   o ディストリビューションの種類 : ${distro}
   o 追加パッケージ : ${application}
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/confirmation' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "c-dev"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] C 開発環境'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
Included packages:
 o autoconf - automatic configure script builder
 o automake - A tool for generating GNU Standards-compliant Makefiles.
 o autoproject - create a skeleton source package for a new program
 o binutils - The GNU assembler, linker and binary utilities
 o bison - A parser generator that is compatible with YACC.
 o c2man - Graham Stoney's mechanized man page generator
 o cflow - C function call hierarchy analyzer
 o cpp - The GNU C preprocessor (cpp)
 o cpp-2.95 - The GNU C preprocessor
 o cpp-3.2 - The GNU C preprocessor
 o cpp-3.3 - The GNU C preprocessor 
 o cutils - C source code utilities
 o cvs  - Concurrent Versions System
 o cxref - Generates latex and HTML documentation for C programs.
 o flex - A fast lexical analyzer generator.
 o g++ - The GNU C++ compiler
 o g++-2.95 - The GNU C++ compiler
 o g++-3.0 - The GNU C++ compiler.
 o g++-3.3 - The GNU C++ compiler
 o gcc - The GNU C compiler
 o gcc-2.95 - The GNU C compiler
 o gcc-3.0 - The GNU C compiler.
 o gcc-3.3 - The GNU C compiler
 o gdb - The GNU Debugger
 o gettext - GNU Internationalization utilities
 o glibc-doc - GNU C Library: Documentation
 o indent - C language source code formatting program
 o libtool - Generic library support script
 o liwc - Tools for manipulating C source code
 o ltrace - Tracks runtime library calls in dynamically linked programs
 o make  - The GNU version of the "make" utility.
 o manpages-dev - Manual pages about using GNU/Linux for development
 o nowebm - A WEB-like literate-programming tool.
 o patch - Apply a diff file to an original
 o stl-manual - C++-STL documentation in HTML
 o strace - A system call tracer
      EXTENDED_DESCRIPTION
end
lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'test/lmp/build'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
