#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$trace = true
$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/specification'
require 'lmp/lmp-package-task'
require 'test/unit'

class TC_LMPPackageTask < Test::Unit::TestCase
  public
  def test_lmp_spec_getter
    lmp_spec = Mock.new( '#<Specification (Mock)>' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :files ) do files end 
    lmp_spec.__next( :files ) do files end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    assert_equal( lmp_spec, lmp_package_task.lmp_spec ) 
    lmp_spec.__verify
  end
  
  public
  def test_define_tasks
    lmp_spec = Mock.new( '#<Specification (Mock)>' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :architecture ) do 'all' end
    lmp_spec.__next( :architecture ) do 'all' end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :architecture ) do 'all' end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    lmp_package_task.define
    
    assert( Task.task_defined?( :package ) )
    assert_equal( ['lmp'], Task[:package].prerequisites )
    assert( Task.task_defined?( :lmp ) )
    assert_equal( ['pkg/LMP-TEST_0.0.1_all.deb'], Task[:lmp].prerequisites )
    assert( Task.task_defined?( 'pkg/LMP-TEST_0.0.1_all.deb' ) )
    assert_equal( ['pkg/debian'] + files.map do |each| "pkg/#{each}" end, Task['pkg/LMP-TEST_0.0.1_all.deb'].prerequisites )
    lmp_spec.__verify
  end
  
  private
  def files
    return ['debian/README.Debian', 
             'debian/changelog', 
             'debian/config', 
             'debian/control', 
             'debian/copyright',
             'debian/postinst',
             'debian/rules',
             'debian/templates',
             'packages'] 
  end
  
  public
  def test_whitebox_test
    Task.clear   
    
    # ------------------------- テンプレート、質問項目の定義.

    require 'deft'
    
    template( 'lucie-vmsetup/hello' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
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
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/num-nodes'
      question.first_question = true
    end
    
    template( 'lucie-vmsetup/num-nodes' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['4', '8', '12', '16', '20', '24', '28', '32', '36', '40', '44', '48', '52', '56', '60', '64']
      template.short_description_ja = 'VM ノードの台数'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM の台数を選択してください。

  松岡研 PrestoIII クラスタで提供できる VM クラスタのノード数は、4 台～ 64 台となっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要な台数を選択してください。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/num-nodes' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/use-network'
    end
    
    template( 'lucie-vmsetup/use-network' ) do |template|
      template.template_type = Deft::BooleanTemplate
      template.default = 'false'
      template.short_description_ja = 'VM の外部ネットワークへの接続'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  ジョブ実行時に VM は外部ネットワークへ接続する必要がありますか？
  このオプションをオンにすると、GRAM が自動的に各 VM に連続した IP アドレスと MAC アドレスを割り当て、
  Lucie をすべてのネットワーク関係の設定を行います。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/use-network' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
    end
    
    template( 'lucie-vmsetup/ip' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'VM の IP アドレス'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
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
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/memory-size'
    end
    
    template( 'lucie-vmsetup/memory-size' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
      template.short_description_ja = 'VM ノードのメモリ容量'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM 一台あたりのメモリ容量を選択してください。単位は MB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのメモリ容量は 640 MB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なメモリ容量を選択してください。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/memory-size' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/harddisk-size'
    end
    
    template( 'lucie-vmsetup/harddisk-size' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['1', '2', '3', '4']
      template.short_description_ja = 'VM ノードのハードディスク容量'  
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  使用したい VM 一台あたりのハードディスク容量を選択してください。単位は GB です。

  松岡研 PrestoIII クラスタで提供できる VM クラスタの１ノードあたりのハードディスク容量は 4GB までとなっています。
  他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要なハードディスク容量を選択してください。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/harddisk-size' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/vm-type'
    end
    
    template( 'lucie-vmsetup/vm-type' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['xen', 'colinux', 'vmware']
      template.short_description_ja = '使用する VM の種類'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  ジョブ実行に使用する VM 実装の種類を選択してください
  .
  松岡研 PrestoIII クラスタで提供できる VM 実装は 
  'Xen (ケンブリッジ大)', 'colinux (www.colinux.org)', 'vmware (VMware, Inc.)' の 3 種類です。
  それぞれの特徴は以下の通りです。
   o Xen: Disk I/O が比較的高速です。
   o coLinux: Network I/O が比較的高速です。
   o vmware: CPU が比較的高速です。
  ジョブの計算内容に合った VM 実装を選択してください。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/vm-type' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/distro'
    end
    
    template( 'lucie-vmsetup/distro' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
      template.short_description_ja = '使用するディストリビューション'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM にインストールして使用する Linux ディストリビューションを選択してください
  .
  松岡研 PrestoIII クラスタで提供できる Linux ディストリビューションは 
  'Debian (woody)', 'Debian (sarge)', 'Redhat 7.3' の 3 種類です。
  それぞれの特徴は以下の通りです。
   o Debian GNU/Linux (woody): Debian の安定版です。
   o Debian GNU/Linux (sarge): Debian の開発版です。比較的新しいパッケージも含まれます。
   o RedHat 7.3: RedHat の安定版です。
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/distro' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = <<-NEXT_QUESTION
      Proc.new do |input|
        case input
        when 'debian (woody)', 'debian (sarge)'
          'lucie-vmsetup/application'
        when 'redhat7.3'
          nil
        end
      end
      NEXT_QUESTION
    end
    
    template( 'lucie-vmsetup/application' ) do |template|
      template.template_type = Deft::StringTemplate
      template.short_description_ja = '使用するアプリケーション'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
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
      question.priority = Deft::Question::PRIORITY_MEDIUM
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
    Task['package'].invoke
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: