#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'date'
require 'lucie/string'

module LMP
  # LMP ���^�f�[�^�t�@�C���̃e���v���[�g���Ǘ����郂�W���[��
  module Template
    public
    # (LMP �r���h�f�B���N�g��)/debian/changelog �̃e���v���[�g�������Ԃ�
    def changelog( aSpecification )
      return <<-CHANGELOG
#{aSpecification.name} (#{aSpecification.version}) stable; urgency=low

 -- #{aSpecification.maintainer}  #{DateTime.now.strftime('%a, %e %b %Y %X %Z')}
      CHANGELOG
    end
    module_function :changelog
    
    # (LMP �r���h�f�B���N�g��)/debian/control �̃e���v���[�g�������Ԃ�
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
    
    # (LMP �r���h�f�B���N�g��)/debian/README.Debian �̃e���v���[�g�������Ԃ�
    public
    def readme( packageNameString )
      return <<-README
#{packageNameString} LMP for Debian

This package is #{packageNameString} Lucie Meta Package.
      README
    end
    module_function :readme
    
    # (LMP �r���h�f�B���N�g��)/debian/rules �̃e���v���[�g�������Ԃ�
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
    
    # (LMP �r���h�f�B���N�g��)/packages �̃e���v���[�g�������Ԃ�
    public
    def packages
      return <<-PACKAGES
# packages �T���v���t�@�C��
#
# �R�����g�̓n�b�V�� (#) �Ŏn�܂�s���܂ő����܂��B
# ���ׂẴR�}���h�� PACKAGES �Ƃ����P��Ŏn�܂�A�R�}���h���������܂��B
# �R�}���h���� apt-get �Ǝ��Ă��܂��B�ȉ����T�|�[�g���Ă���R�}���h����
# ���X�g�ł��B
#
# hold:
#    �p�b�P�[�W���z�[���h���܂��B�z�[���h�����p�b�P�[�W�̓A�b�v�O���[�h����܂�
#    ��B
#    
# install:
#    ��̍s�ɑ������ׂẴp�b�P�[�W���C���X�g�[������܂��B
#
# remove:
#    ��̍s�ɑ������ׂẴp�b�P�[�W���A���C���X�g�[������܂��B
#
# taskinst:
#    tasksel(1)�ɂ���Č�̍s�ɑ����^�X�N�Ɋ܂܂�邷�ׂẴp�b�P�[�W���C���X�g
#    �[������܂��B
#
# dselect-upgrade
#    ��̍s�ɑ����p�b�P�[�W�Ńp�b�P�[�W�Z���N�V�������Z�b�g���A�w�肳�ꂽ�p�b�P
#    �[�W���C���X�g�[���������̓A���C���X�g�[�����܂��B
#
# �ݒ��:
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