#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/builder'
require 'test/unit'

class TC_Builder < Test::Unit::TestCase
  public
  def test_build
    spec = Mock.new( '[SPEC]' )
    spec.__next( :builddir ) do 'test/lmp/build' end
    spec.__next( :builddir ) do 'test/lmp/build' end
    spec.__next( :name ) do 'lmp-test' end 
    spec.__next( :readme ) do end 
    spec.__next( :changelog ) do <<-CHANGELOG
lmp-test (0.1-1) unstable; urgency=low

  * Initial Release.
  
 -- Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>  Mon, 26 Jul 2004 15:28:39 +0900
    CHANGELOG
    end
    spec.__next( :config ) do end
    spec.__next( :control ) do <<-CONTROL
Source: lmp-test
Priority: optional
Section: misc
Maintainer: Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>
Build-Depends: debhelper (>= 4.0.0)
Standards-Version: 3.6.0

Package: lmp-test
Architecture: all
Description: Lucie メタパッケージのテスト
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
    CONTROL
    end
    spec.__next( :copyright ) do end
    spec.__next( :postinst ) do end
    spec.__next( :rules ) do <<-RULES
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
	install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev
	install $(CURDIR)/packages $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev
	install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev/files/
	-cp -a $(CURDIR)/files/* $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev/files/
	install -d $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev/scripts/
	-cp -a $(CURDIR)/scripts/* $(CURDIR)/debian/tmp/etc/lucie/lmp/c-dev/scripts/

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
    spec.__next( :templates ) do end
    builder = LMP::Builder.new( spec )
    builder.build
    
    assert( FileTest.directory?( 'test/lmp/build' ), 'ビルドディレクトリができていない' )
    assert( FileTest.directory?( 'test/lmp/build/lmp-test/debian' ), 'debian ディレクトリができていない' )
    test_debian_package_file( 'README.Debian' )
    test_debian_package_file( 'changelog' )
    test_debian_package_file( 'config' )
    test_debian_package_file( 'control' )
    test_debian_package_file( 'copyright' )
    test_debian_package_file( 'postinst' )
    test_debian_package_file( 'rules' )
    test_debian_package_file( 'templates' )

    assert( FileTest.exist?( 'build/lmp-test.deb' ), 'lmp ができていない' )
  end
  
  private
  def test_debian_package_file( fileNameString )
    assert( FileTest.exists?( "test/lmp/build/lmp-test/debian/#{fileNameString}" ), "#{fileNameString} ファイルができていない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
