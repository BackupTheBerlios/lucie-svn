#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rubygems'
require 'rake/packagetask'
require 'lmp/builder'

module Rake
  # Specification �Ɋ�Â��� LMP ���r���h����^�X�N�B
  #
  # PackageTask �ɂ���Đ�������� Rake �^�[�Q�b�g�ɉ����A
  # LMPPackageTask �͎��̃^�X�N�𐶐�����B
  #
  # [<b>"<em>package_dir</em>/<em>name</em>-<em>version</em>.deb"</b>]
  #  �^����ꂽ���O�ƃo�[�W���������� LMP �p�b�P�[�W���쐬����
  #
  # LMP �� Specification ��p�����ꍇ�̎g�p��:
  #
  #  spec = LMP::Specification.new do |spec|
  #    spec.name = "c-dev"
  #    spec.version = "0.0.1"
  #    spec.short_description = '[���^�p�b�P�[�W] C �J����'
  #    spec.extended_description = <<-EXTENDED_DESCRIPTION
  #  Included packages:
  #   o autoconf - automatic configure script builder
  #   o automake - A tool for generating GNU Standards-compliant Makefiles.
  #   o autoproject - create a skeleton source package for a new program
  #   o binutils - The GNU assembler, linker and binary utilities
  #   o bison - A parser generator that is compatible with YACC.
  #   o c2man - Graham Stoney's mechanized man page generator
  #   o cflow - C function call hierarchy analyzer
  #   o cpp - The GNU C preprocessor (cpp)
  #   o cpp-2.95 - The GNU C preprocessor
  #   o cpp-3.2 - The GNU C preprocessor
  #   o cpp-3.3 - The GNU C preprocessor
  #   o cutils - C source code utilities
  #   o cvs  - Concurrent Versions System
  #   o cxref - Generates latex and HTML documentation for C programs.
  #   o flex - A fast lexical analyzer generator.
  #   o g++ - The GNU C++ compiler
  #   o g++-2.95 - The GNU C++ compiler
  #   o g++-3.0 - The GNU C++ compiler.
  #   o g++-3.3 - The GNU C++ compiler
  #   o gcc - The GNU C compiler
  #   o gcc-2.95 - The GNU C compiler
  #   o gcc-3.0 - The GNU C compiler.
  #   o gcc-3.3 - The GNU C compiler
  #   o gdb - The GNU Debugger
  #   o gettext - GNU Internationalization utilities
  #   o glibc-doc - GNU C Library: Documentation
  #   o indent - C language source code formatting program
  #   o libtool - Generic library support script
  #   o liwc - Tools for manipulating C source code
  #   o ltrace - Tracks runtime library calls in dynamically linked programs
  #   o make  - The GNU version of the "make" utility.
  #   o manpages-dev - Manual pages about using GNU/Linux for development
  #   o nowebm - A WEB-like literate-programming tool.
  #   o patch - Apply a diff file to an original
  #   o stl-manual - C++-STL documentation in HTML
  #   o strace - A system call tracer
  #    EXTENDED_DESCRIPTION
  #  end
  #
  #  Rake::LMPPackageTask.new( spec ) do |pkg|
  #    pkg.package_dir = "test/lmp/build/#{pkg.name}"
  #    pkg.need_deb = true
  #  end
  #
  #
  class LMPPackageTask < PackageTask
    # LMP �p�b�P�[�W�̃��^�f�[�^���܂ރX�y�b�N�B�p�b�P�[�W���A�o�[�W���� 
    # ����� package_files �͎����I�� LMP �X�y�b�N���猈�肳��邽�߁A��  
    # ���I�ɓn���K�v�͖����B
    attr_accessor :lmp_spec
    # deb �t�@�C���𐶐�����Ƃ��� true (�f�t�H���g : false)
    attr_accessor :need_deb 

    # LMP �p�b�P�[�W�p Rake �^�X�N�̃��C�u�����𐶐�����B
    # �u���b�N���^����ꂽ�ꍇ�A�����I�� LMP ���`����B
    # �����^�����Ȃ������ꍇ�A�^�X�N���`���邽�߂ɂ͖����I��
    # +define+ ���Ăяo���K�v������B    
    public
    def initialize( aSpecification )
      init( aSpecification )
      yield self if block_given?
      define if block_given?
    end
    
    # �^�X�N������������B
    # "yield self" �� define �̑O�Ɏ��s�����B
    public
    def init( aSpecification )
      super( aSpecification.name, aSpecification.version )
      @lmp_spec = aSpecification
      @package_files += @lmp_spec.files if @lmp_spec.files
    end
    
    # LMPPackageTask �Ŏw�肳��� Rake �̃^�X�N�ƃA�N�V�������`����B
    # (�u���b�N�� +new+ �֓n���ꂽ�ۂɂ� +define+ �͎����I�ɌĂ΂��)
    public
    def define
      super
      @builder = LMP::Builder.new( @lmp_spec, @package_dir )
      directory debian_dir
      task :package => [:lmp]
      task :lmp => ["#{package_dir}/#{lmp_file}"]
      package_metadata_files = @lmp_spec.files.map do |each| "#{package_dir}/#{each}" end
      file "#{package_dir}/#{lmp_file}" => [debian_dir] + package_metadata_files do
        when_writing( 'Creating LMP' ) do
          @builder.build          
        end
      end
    end
    
    private
    def debian_dir
      return File.join( [package_dir, 'debian'] )
    end
    
    private
    def lmp_file
      return "#{package_name}.deb"
    end
    
    private
    def package_name
      return "#{@name}_#{@version}_#{@lmp_spec.architecture}"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: