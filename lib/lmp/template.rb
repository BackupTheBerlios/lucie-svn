#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'date'
require 'lucie/string'

module LMP
  # LMP メタデータファイルのテンプレートを管理するモジュール
  module Template
    public
    # (LMP ビルドディレクトリ)/debian/changelog のテンプレート文字列を返す
    def changelog( aSpecification )
      return <<-CHANGELOG
#{aSpecification.name} (#{aSpecification.version}) stable; urgency=low

 -- #{aSpecification.maintainer}  #{DateTime.now.strftime('%a, %e %b %Y %X %Z')}
      CHANGELOG
    end
    module_function :changelog
    
    # (LMP ビルドディレクトリ)/debian/control のテンプレート文字列を返す
    public
    def control( aSpecification )
      return (<<-SPECIFICATION) + aSpecification.extended_description.unindent_auto.to_rfc822
Source: #{aSpecification.name}
Priority: #{aSpecification.priority}   
Section: #{aSpecification.section}   
Maintainer: #{aSpecification.maintainer}
Build-Depends: debhelper (>= 4.0.0)
Standards-Version: 3.6.0
      
Package: #{aSpecification.name}
Architecture: #{aSpecification.architecture}
Description: #{aSpecification.short_description}
      SPECIFICATION
    end
    module_function :control
    
    # (LMP ビルドディレクトリ)/debian/README.Debian のテンプレート文字列を返す
    public
    def readme( packageNameString )
      return <<-README
#{packageNameString} LMP for Debian

This package is #{packageNameString} Lucie Meta Package.
      README
    end
    module_function :readme
    
    # (LMP ビルドディレクトリ)/debian/rules のテンプレート文字列を返す
    public
    def rules( packageNameString )
      return <<-RULES
#!/usr/bin/make -f
# -*- makefile -*-

configure: configure-stamp
configure-stamp:
    dh_testdir
    # Add here commands to configure the package.

    touch configure-stamp


build: build-stamp

build-stamp: configure-stamp 
    dh_testdir

    # Add here commands to compile the package.
    # $(MAKE)
    #/usr/bin/docbook-to-man debian/lmp-test.sgml > lmp-test.1

    touch build-stamp

clean:
    dh_testdir
    dh_testroot
    rm -f build-stamp configure-stamp

    # Add here commands to clean up after the build process.
    -$(MAKE) clean

    dh_clean 

install: build
    dh_testdir
    dh_testroot
    dh_clean -k 
    dh_installdirs

    # Add here commands to install the package into debian/lmp-test.
    # $(MAKE) install DESTDIR=$(CURDIR)/debian/lmp-test
    install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}
    install $(CURDIR)/packages $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}
    install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}/files/
    -cp -a $(CURDIR)/files/* $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}/files/
    install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}/scripts/
    -cp -a $(CURDIR)/scripts/* $(CURDIR)/debian/tmp/etc/lucie/lmp/#{packageNameString}/scripts/


# Build architecture-independent files here.
binary-indep: build install
# We have nothing to do by default.

# Build architecture-dependent files here.
binary-arch: build install
    dh_testdir
    dh_testroot
    dh_installchangelogs 
    dh_installdocs
    dh_install
    dh_installdebconf   
    dh_link
    dh_compress
    dh_fixperms
    dh_installdeb
    dh_shlibdeps
    dh_gencontrol
    dh_md5sums
    dh_builddeb

binary: binary-indep binary-arch
.PHONY: build clean binary-indep binary-arch binary install configure
      RULES
    end
    module_function :rules
    
    # (LMP ビルドディレクトリ)/packages のテンプレート文字列を返す
    public
    def packages
      return <<-PACKAGES
# packages サンプルファイル
#
# コメントはハッシュ (#) で始まり行末まで続きます。
# すべてのコマンドは PACKAGES という単語で始まり、コマンド名が続きます。
# コマンド名は apt-get と似ています。以下がサポートしているコマンド名の
# リストです。
#
# hold:
#    パッケージをホールドします。ホールドしたパッケージはアップグレードされませ
#    ん。
#    
# install:
#    後の行に続くすべてのパッケージがインストールされます。
#
# remove:
#    後の行に続くすべてのパッケージがアンインストールされます。
#
# taskinst:
#    tasksel(1)によって後の行に続くタスクに含まれるすべてのパッケージがインスト
#    ールされます。
#
# dselect-upgrade
#    後の行に続くパッケージでパッケージセレクションをセットし、指定されたパッケ
#    ージをインストールもしくはアンインストールします。
#
# 設定例:
# 
# PACKAGES taskinst
# german science
#    
# PACKAGES install
# adduser netstd ae
# less passwd
#     
# PACKAGES remove
# gpm xdm
#     
# PACKAGES dselect-upgrade
# ddd                     install
# a2ps                    install    
      PACKAGES
    end
    module_function :packages
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: