# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift 'lib'

require 'depends/package'
require 'test/unit'

class TC_Package < Test::Unit::TestCase
  public
  def test_accessors
    spec = <<CONTROL
Package: lv
Essential: yes
Status: install ok installed
Priority: optional
Section: text
Installed-Size: 628
Maintainer: GOTO Masanori <gotom@debian.or.jp>
Architecture: i386
Source: lvsource
Version: 4.49.4-8
Provides: liblv-dev
Replaces: lv (<< 3.0.0)
Depends: libc6 (>= 2.2.5-13), libncurses5 (>= 5.2.20020112a-1)
Recommends: bzip2
Filename: pool/main/l/lv/lv_4.49.4-8_i386.deb
Size: 414622
MD5sum: 0f6e74e775932f6e5fe5d22292a06090
Conflicts: xlibs (<< 4.3.0)
Suggests: cvs
Conffiles:
 /etc/debconf.conf eb448d7ec3a6258c8601e6b27284b791
 /etc/apt/apt.conf.d/70debconf 7e9d09d5801a42b4926b736b8eeabb73
Description: Powerful Multilingual File Viewer
 lv is a powerful file viewer like less.
 lv can decode and encode multilingual streams through
 many coding systems:
 ISO-8859, ISO-2022, EUC, SJIS, Big5, HZ, Unicode.
 .
 It recognizes multi-bytes patterns as regular
 expressions, lv also provides multilingual grep.
 In addition, lv can recognize ANSI escape sequences
 for text decoration.
Task: japanese
CONTROL
    lv_package = Depends::Package.new( spec )

    assert_equal( 'lv', lv_package.name, 'name 属性が取得できない' )
    assert_equal( 'optional', lv_package.priority, 'priority 属性が取得できない' )
    assert_equal( 'text', lv_package.section, 'section 属性が取得できない' )
    assert_equal( 628, lv_package.installed_size, 'installed_size 属性が取得できない' ) 
    assert_equal( 'GOTO Masanori <gotom@debian.or.jp>', lv_package.maintainer, 'maintainer 属性が取得できない' )
    assert_equal( '4.49.4-8', lv_package.version, 'version 属性が取得できない' )
    assert_kind_of( Array, lv_package.depends, 'depends 属性が Array でない' )
    assert_equal( 2, lv_package.depends.size, '依存しているパッケージの数が違う' )
    assert_equal( 'libc6', lv_package.depends[0].name, '依存しているパッケージの名前が違う' )
    assert_equal( 'libncurses5', lv_package.depends[1].name, '依存しているパッケージの名前が違う' )
    assert_kind_of( Proc, lv_package.depends[0].relation, '依存しているパッケージの relation の型が違う' )
    assert_kind_of( Proc, lv_package.depends[1].relation, '依存しているパッケージの relation の型が違う' )
    assert_equal( 'bzip2', lv_package.recommends, 'recommends 属性が取得できない' )
    assert_equal( 'Powerful Multilingual File Viewer', lv_package.short_description, 'short description 属性が取得できない' )
    assert_equal( ['install', 'ok', 'installed'], lv_package.status, 'status 属性が取得できない' )
    assert_equal( 'xlibs (<< 4.3.0)', lv_package.conflicts, 'conflicts 属性が取得できない' )
    assert_equal( 'lvsource', lv_package.source, 'source 属性が取得できない' )
    assert_equal( ['liblv-dev'], lv_package.provides, 'provides 属性が取得できない' )
    assert_equal( 'cvs', lv_package.suggests, 'suggests 属性が取得できない' )
    assert_equal( 'yes', lv_package.essential, 'essential 属性が取得できない' )
    assert_equal( 'lv (<< 3.0.0)', lv_package.replaces, 'replaces 属性が取得できない' )
    assert_equal( ['/etc/debconf.conf eb448d7ec3a6258c8601e6b27284b791', 
                    '/etc/apt/apt.conf.d/70debconf 7e9d09d5801a42b4926b736b8eeabb73'], lv_package.conffiles, 'conffiles 属性が取得できない' )
    assert_equal( (<<-DESCRIPTION).chomp, lv_package.description, 'description 属性が取得できない' )
lv is a powerful file viewer like less.
lv can decode and encode multilingual streams through
many coding systems:
ISO-8859, ISO-2022, EUC, SJIS, Big5, HZ, Unicode.
.
It recognizes multi-bytes patterns as regular
expressions, lv also provides multilingual grep.
In addition, lv can recognize ANSI escape sequences
for text decoration.
DESCRIPTION
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
