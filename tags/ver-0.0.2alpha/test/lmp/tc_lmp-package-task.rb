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
    
    # ------------------------- �e���v���[�g�A���⍀�ڂ̒�`.

    require 'deft'
    
    template( 'lucie-vmsetup/hello' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���̃E�B�U�[�h�ł́ALucie ��p���� VM �Z�b�g�A�b�v�̐ݒ����͂��܂��B
  �ݒ�\�ȍ��ڂ́A
   o �K�v�� VM �̑䐔
   o �O���l�b�g���[�N�ւ̐ڑ�
   o VM �Ŏg�p���郁�����e��
   o VM �Ŏg�p����n�[�h�f�B�X�N�e��
   o �g�p���� VM �̎��
   o VM �փC���X�g�[������ Linux �f�B�X�g���r���[�V�����̎��
   o VM �փC���X�g�[������\�t�g�E�F�A�̎��
  �ł��B������ VM ��ő��点�����W���u�̓����ɂ���Đݒ�����߂Ă��������B

  �u���ցv���N���b�N����ƃE�B�U�[�h���J�n���܂��B
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
      template.short_description_ja = 'VM �m�[�h�̑䐔'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM �̑䐔��I�����Ă��������B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̃m�[�h���́A4 ��` 64 ��ƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȑ䐔��I�����Ă��������B
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/num-nodes' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/use-network'
    end
    
    template( 'lucie-vmsetup/use-network' ) do |template|
      template.template_type = Deft::BooleanTemplate
      template.default = 'false'
      template.short_description_ja = 'VM �̊O���l�b�g���[�N�ւ̐ڑ�'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �W���u���s���� VM �͊O���l�b�g���[�N�֐ڑ�����K�v������܂����H
  ���̃I�v�V�������I���ɂ���ƁAGRAM �������I�Ɋe VM �ɘA������ IP �A�h���X�� MAC �A�h���X�����蓖�āA
  Lucie �����ׂẴl�b�g���[�N�֌W�̐ݒ���s���܂��B
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/use-network' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
    end
    
    template( 'lucie-vmsetup/ip' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'VM �� IP �A�h���X'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �ȉ��̂悤�Ƀz�X�g���AIP �A�h���X�AMAC �A�h���X������U��܂����B
  �g�p�\�� VM �� pad000 - pad003 �� 4 �m�[�h�ł��B
  
   �z�X�g��: pad000
   IP �A�h���X: 168.220.98.30
   MAC �A�h���X: 00:50:56:01:02:02

   �z�X�g��: pad001
   IP �A�h���X: 163.220.98.31
   MAC �A�h���X: 00:50:56:01:02:03

   �z�X�g��: pad002
   IP �A�h���X: 163.220.98.32
   MAC �A�h���X: 00:50:56:01:02:04

   �z�X�g��: pad003
   IP �A�h���X: 163.220.98.33
   MAC �A�h���X: 00:50:56:01:02:05
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/ip' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/memory-size'
    end
    
    template( 'lucie-vmsetup/memory-size' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
      template.short_description_ja = 'VM �m�[�h�̃������e��'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM ��䂠����̃������e�ʂ�I�����Ă��������B�P�ʂ� MB �ł��B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̂P�m�[�h������̃������e�ʂ� 640 MB �܂łƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȃ������e�ʂ�I�����Ă��������B
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/memory-size' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/harddisk-size'
    end
    
    template( 'lucie-vmsetup/harddisk-size' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['1', '2', '3', '4']
      template.short_description_ja = 'VM �m�[�h�̃n�[�h�f�B�X�N�e��'  
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �g�p������ VM ��䂠����̃n�[�h�f�B�X�N�e�ʂ�I�����Ă��������B�P�ʂ� GB �ł��B

  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM �N���X�^�̂P�m�[�h������̃n�[�h�f�B�X�N�e�ʂ� 4GB �܂łƂȂ��Ă��܂��B
  ���̃W���u�։e����^���Ȃ��悤�ɁA�W���u���s�� *�Œ��* �K�v�ȃn�[�h�f�B�X�N�e�ʂ�I�����Ă��������B
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/harddisk-size' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/vm-type'
    end
    
    template( 'lucie-vmsetup/vm-type' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['xen', 'colinux', 'vmware']
      template.short_description_ja = '�g�p���� VM �̎��'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  �W���u���s�Ɏg�p���� VM �����̎�ނ�I�����Ă�������
  .
  ������ PrestoIII �N���X�^�Œ񋟂ł��� VM ������ 
  'Xen (�P���u���b�W��)', 'colinux (www.colinux.org)', 'vmware (VMware, Inc.)' �� 3 ��ނł��B
  ���ꂼ��̓����͈ȉ��̒ʂ�ł��B
   o Xen: Disk I/O ����r�I�����ł��B
   o coLinux: Network I/O ����r�I�����ł��B
   o vmware: CPU ����r�I�����ł��B
  �W���u�̌v�Z���e�ɍ����� VM ������I�����Ă��������B
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/vm-type' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'lucie-vmsetup/distro'
    end
    
    template( 'lucie-vmsetup/distro' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
      template.short_description_ja = '�g�p����f�B�X�g���r���[�V����'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �ɃC���X�g�[�����Ďg�p���� Linux �f�B�X�g���r���[�V������I�����Ă�������
  .
  ������ PrestoIII �N���X�^�Œ񋟂ł��� Linux �f�B�X�g���r���[�V������ 
  'Debian (woody)', 'Debian (sarge)', 'Redhat 7.3' �� 3 ��ނł��B
  ���ꂼ��̓����͈ȉ��̒ʂ�ł��B
   o Debian GNU/Linux (woody): Debian �̈���łł��B
   o Debian GNU/Linux (sarge): Debian �̊J���łł��B��r�I�V�����p�b�P�[�W���܂܂�܂��B
   o RedHat 7.3: RedHat �̈���łł��B
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
      template.short_description_ja = '�g�p����A�v���P�[�V����'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �ɃC���X�g�[�����Ďg�p����\�t�g�E�F�A�p�b�P�[�W����͂��Ă�������

  ������ PrestoIII �N���X�^�Ńf�t�H���g�ŃC���X�g�[�������\�t�g�E�F�A�p�b�P�[�W�͈ȉ��̒ʂ�ł��B
   o ��{�p�b�P�[�W: fileutils, findutils �Ȃǂ̊�{�I�ȃ��[�e�B���e�B
   o �V�F��: tcsh, bash, zsh �Ȃǂ̃V�F��
   o �l�b�g���[�N�f�[����: ssh �� rsh, ftp �Ȃǂ̃f�[����
  ��L�ɒǉ����ăC���X�g�[���������p�b�P�[�W���R���}��؂�œ��͂��Ă��������B
  
  ��: ruby, python, blast2
      DESCRIPTION_JA
    end
    
    question( 'lucie-vmsetup/application' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end

    # ------------------------- LMP �̒�`.

    spec = LMP::Specification.new do |spec|
      spec.name = "c-dev"
      spec.version = "0.0.1-1"
      spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
      spec.short_description = '[���^�p�b�P�[�W] C �J����'
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