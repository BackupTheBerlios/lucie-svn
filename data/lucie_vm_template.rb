#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'

include Deft

# ------------------------- template �� question �����.

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'Lucie VM �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Υ��������ɤǤϡ�Lucie ���Ѥ��� VM ���åȥ��åפ���������Ϥ��ޤ���
  �����ǽ�ʹ��ܤϡ�
   o ɬ�פ� VM �����
   o �����ͥåȥ���ؤ���³
   o VM �ǻ��Ѥ����������
   o VM �ǻ��Ѥ���ϡ��ɥǥ���������
   o ���Ѥ��� VM �μ���
   o VM �إ��󥹥ȡ��뤹�� Linux �ǥ����ȥ�ӥ塼�����μ���
   o VM �إ��󥹥ȡ��뤹�륽�եȥ������μ���
  �Ǥ�����ʬ�� VM ������餻��������֤������ˤ�ä��������Ƥ���������

  �ּ��ءפ򥯥�å�����ȥ��������ɤ򳫻Ϥ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/num-nodes'
  question.first_question = true
end

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['4', '8', '12', '16', '20', '24', '28', '32', '36', '40', '44', '48', '52', '56', '60', '64']
  template.short_description_ja = 'VM �Ρ��ɤ����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ����������򤷤Ƥ���������

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���ΥΡ��ɿ��ϡ�4 ��� 64 ��ȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/use-network'
end

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = BooleanTemplate
  template.default = 'false'
  template.short_description_ja = 'VM �γ����ͥåȥ���ؤ���³'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ����ּ¹Ի��� VM �ϳ����ͥåȥ������³����ɬ�פ�����ޤ�����
  ���Υ��ץ����򥪥�ˤ���ȡ�GRAM ����ưŪ�˳� VM ��Ϣ³���� IP ���ɥ쥹�� MAC ���ɥ쥹�������ơ�
  Lucie �򤹤٤ƤΥͥåȥ���ط��������Ԥ��ޤ���
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
end

template( 'lucie-vmsetup/ip' ) do |template|
  template.template_type = NoteTemplate
  template.short_description_ja = 'VM �� IP ���ɥ쥹'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  �ʲ��Τ褦�˥ۥ���̾��IP ���ɥ쥹��MAC ���ɥ쥹���꿶��ޤ�����
  ���Ѳ�ǽ�� VM �� pad000 - pad003 �� 4 �Ρ��ɤǤ���
  
   �ۥ���̾: pad000
   IP ���ɥ쥹: 168.220.98.30
   MAC ���ɥ쥹: 00:50:56:01:02:02

   �ۥ���̾: pad001
   IP ���ɥ쥹: 163.220.98.31
   MAC ���ɥ쥹: 00:50:56:01:02:03

   �ۥ���̾: pad002
   IP ���ɥ쥹: 163.220.98.32
   MAC ���ɥ쥹: 00:50:56:01:02:04

   �ۥ���̾: pad003
   IP ���ɥ쥹: 163.220.98.33
   MAC ���ɥ쥹: 00:50:56:01:02:05
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['64', '128', '192', '256', '320', '384', '448', '512', '576', '640']
  template.short_description_ja = 'VM �Ρ��ɤΥ�������'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ���椢����Υ������̤����򤷤Ƥ���������ñ�̤� MB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υ������̤� 640 MB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥ������̤����򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

template( 'lucie-vmsetup/harddisk-size' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['1', '2', '3', '4']
  template.short_description_ja = 'VM �Ρ��ɤΥϡ��ɥǥ���������'  
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ���Ѥ����� VM ���椢����Υϡ��ɥǥ��������̤����򤷤Ƥ���������ñ�̤� GB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υϡ��ɥǥ��������̤� 4GB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥϡ��ɥǥ��������̤����򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

template( 'lucie-vmsetup/vm-type' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['xen', 'colinux', 'vmware']
  template.short_description_ja = '���Ѥ��� VM �μ���'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  ����ּ¹Ԥ˻��Ѥ��� VM �����μ�������򤷤Ƥ�������
  .
  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ������ 
  'Xen (����֥�å���)', 'colinux (www.colinux.org)', 'vmware (VMware, Inc.)' �� 3 ����Ǥ���
  ���줾�����ħ�ϰʲ����̤�Ǥ���
   o Xen: Disk I/O �����Ū��®�Ǥ���
   o coLinux: Network I/O �����Ū��®�Ǥ���
   o vmware: CPU �����Ū��®�Ǥ���
  ����֤η׻����Ƥ˹�ä� VM ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

template( 'lucie-vmsetup/distro' ) do |template|
  template.template_type = SelectTemplate
  template.choices = ['debian (woody)', 'debian (sarge)', 'redhat7.3']
  template.short_description_ja = '���Ѥ���ǥ����ȥ�ӥ塼�����'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��� Linux �ǥ����ȥ�ӥ塼���������򤷤Ƥ�������
  .
  ������ PrestoIII ���饹�����󶡤Ǥ��� Linux �ǥ����ȥ�ӥ塼������ 
  'Debian (woody)', 'Debian (sarge)', 'Redhat 7.3' �� 3 ����Ǥ���
  ���줾�����ħ�ϰʲ����̤�Ǥ���
   o Debian GNU/Linux (woody): Debian �ΰ����ǤǤ���
   o Debian GNU/Linux (sarge): Debian �γ�ȯ�ǤǤ������Ū�������ѥå�������ޤޤ�ޤ���
   o RedHat 7.3: RedHat �ΰ����ǤǤ���
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
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
  template.template_type = StringTemplate
  template.short_description_ja = '���Ѥ��륢�ץꥱ�������'
  template.extended_description_ja = (<<-DESCRIPTION_JA)
  VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��륽�եȥ������ѥå����������Ϥ��Ƥ�������

  ������ PrestoIII ���饹���ǥǥե���Ȥǥ��󥹥ȡ��뤵��륽�եȥ������ѥå������ϰʲ����̤�Ǥ���
   o ���ܥѥå�����: fileutils, findutils �ʤɤδ���Ū�ʥ桼�ƥ���ƥ�
   o ������: tcsh, bash, zsh �ʤɤΥ�����
   o �ͥåȥ���ǡ����: ssh �� rsh, ftp �ʤɤΥǡ����
  �嵭���ɲä��ƥ��󥹥ȡ��뤷�����ѥå������򥳥�޶��ڤ�����Ϥ��Ƥ���������
  
  ��: ruby, python, blast2
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- LMP �����.

spec = LMP::Specification.new do |spec|
  spec.name = "c-dev"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[�᥿�ѥå�����] C ��ȯ�Ķ�'
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
