#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'

include Deft

# ------------------------- ���顼ɽ���ѥƥ�ץ졼��/���� 

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
  template.short_description_ja = 'Lucie VM �Υ��åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
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
  question.next_question = 'lucie-vmsetup/vmpool-server-ip'
  question.first_question = true
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-ip' ) do |template|
  template.template_type = 'string'
  template.default = '127.0.0.1'
  template.short_description_ja = 'Lucie VM Pool �����Ф� IP ���ɥ쥹'
  template.extended_description_ja = 'Lucie VM Pool �����Ф� IP ���ɥ쥹�����Ϥ��Ƥ�������'
end

question( 'lucie-vmsetup/vmpool-server-ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    unless /\\A\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}\\Z/=~ user_input
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: IP ���ɥ쥹����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "IP ���ɥ쥹�η���������������ޤ��� : \#{get('lucie-vmsetup/vmpool-server-ip')}"
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
  template.short_description_ja = 'Lucie VM Pool �����ФΥݡ����ֹ�'
  template.extended_description_ja = 'Lucie VM Pool �����ФΥݡ����ֹ�����Ϥ��Ƥ�������'
end

question( 'lucie-vmsetup/vmpool-server-port' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    unless /\\A\\d+\\Z/=~ user_input
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: �ݡ����ֹ����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "�ݡ����ֹ�η���������������ޤ��� : \#{get('lucie-vmsetup/vmpool-server-port')}"
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
  template.short_description_ja = 'Lucie VM Pool �����Фغ���³'
  template.extended_description_ja = <<-DESCRIPTION_JA
  Lucie VM Pool �����Фؤ���³�˼��Ԥ��ޤ�����
   o IP ���ɥ쥹 ${vmpool-server-ip}
   o �ݡ����ֹ� ${vmpool-server-port}
  ����³���ޤ�����
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
      subst 'lucie-vmsetup/error-abort', 'short_error_message', 'Lucie VM Pool ���åȥ��åפ����'
      subst 'lucie-vmsetup/error-abort', 'extended_error_message', 'Lucie VM Pool �Υ��åȥ��åפ���ߤ��ޤ�'
      'lucie-vmsetup/error-abort'
    end
  end 
  NEXT_QUESTION
end

# ------------------------- 

template( 'lucie-vmsetup/vmpool-server-confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = 'Lucie VM Pool ����γ�ǧ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ��������� Lucie VM Pool �����Ф���³���ޤ�
   o IP ���ɥ쥹 ${vmpool-server-ip}
   o �ݡ����ֹ� ${vmpool-server-port}
  ��Next�� �򲡤�����³���ޤ���
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
  template.short_description_ja = 'VM �Ρ��ɤ����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Ѥ����� VM ����������򤷤Ƥ���������

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���ΥΡ��ɿ��ϡ�${num-nodes}��ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤ����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤ���������åȤ���Ƥ��ޤ���"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $num_nodes_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤ����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤ��������¤� \#{$num_nodes_upperbound} ���ۤ��Ƥ��ޤ���"
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
  template.short_description_ja = 'VM �γ����ͥåȥ���ؤ���³'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ����ּ¹Ի��� VM �ϳ����ͥåȥ������³����ɬ�פ�����ޤ�����
  ���Υ��ץ����򥪥�ˤ���ȡ�GRAM ����ưŪ�˳� VM ��Ϣ³���� IP ���ɥ쥹�� MAC ���ɥ쥹�������ơ�
  Lucie �򤹤٤ƤΥͥåȥ���ط��������Ԥ��ޤ���
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
  template.short_description_ja = 'VM �� IP ���ɥ쥹'
  template.extended_description_ja = <<-DESCRIPTION_JA
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

# ------------------------- 

template( 'lucie-vmsetup/memory-size' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'VM �Ρ��ɤΥ��ꥵ����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Ѥ����� VM ���椢����Υ��ꥵ���������򤷤Ƥ���������ñ�̤� MB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υ��ꥵ������ ${memory-size}MB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥ��ꥵ���������򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤΥ��ꥵ����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤΥ��ꥵ���������åȤ���Ƥ��ޤ���"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $memory_size_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤΥ��ꥵ����"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤΥ��ꥵ��������¤� \#{$memory_size_upperbound} MB ��ۤ��Ƥ��ޤ���"
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
  template.short_description_ja = 'VM �Ρ��ɤΥϡ��ɥǥ���������'  
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Ѥ����� VM ���椢����Υϡ��ɥǥ��������̤����򤷤Ƥ���������ñ�̤� GB �Ǥ���

  ������ PrestoIII ���饹�����󶡤Ǥ��� VM ���饹���Σ��Ρ��ɤ�����Υϡ��ɥǥ��������̤� ${harddisk-size}GB �ޤǤȤʤäƤ��ޤ���
  ¾�Υ���֤رƶ���Ϳ���ʤ��褦�ˡ�����ּ¹Ԥ� *�����* ɬ�פʥϡ��ɥǥ��������̤����򤷤Ƥ���������
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    if user_input.to_i <= 0
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤΥϡ��ɥǥ���������"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤΥϡ��ɥǥ��������̤����åȤ���Ƥ��ޤ���"
      'lucie-vmsetup/error-backup'
    elsif user_input.to_i > $harddisk_size_upperbound
      subst 'lucie-vmsetup/error-backup', 'short_error_message', "���顼: VM �Ρ��ɤΥϡ��ɥǥ���������"
      subst 'lucie-vmsetup/error-backup', 'extended_error_message', "VM �Ρ��ɤΥϡ��ɥǥ��������̤���¤� \#{$harddisk_size_upperbound} GB ��ۤ��Ƥ��ޤ���"
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
  template.short_description_ja = '���Ѥ��� VM �μ���'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ����ּ¹Ԥ˻��Ѥ��� VM �����μ�������򤷤Ƥ�������
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
  template.short_description_ja = '���Ѥ���ǥ����ȥ�ӥ塼�����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  VM �˥��󥹥ȡ��뤷�ƻ��Ѥ��� Linux �ǥ����ȥ�ӥ塼���������򤷤Ƥ�������
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
  template.short_description_ja = '���Ѥ��륢�ץꥱ�������'
  template.extended_description_ja = <<-DESCRIPTION_JA
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
  question.next_question = <<-NEXT_QUESTION
  Proc.new do |user_input|
    subst 'lucie-vmsetup/confirmation', 'application', user_input	    	
    'lucie-vmsetup/confirmation'
  end
  NEXT_QUESTION
end

# ------------------------- �������γ�ǧ

template( 'lucie-vmsetup/confirmation' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '�������γ�ǧ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���������ǧ���ޤ���
   o ���Ѥ��� VM ��� : ${num_nodes}��
   o �ͥåȥ���ؤ���³ : ${use_network}
   o ���ꥵ���� : ${memory_size}MB
   o �ϡ��ɥǥ����������� : ${harddisk_size}GB
   o VM �μ��� : ${vm_type}
   o �ǥ����ȥ�ӥ塼�����μ��� : ${distro}
   o �ɲåѥå����� : ${application}
  DESCRIPTION_JA
end

question( 'lucie-vmsetup/confirmation' ) do |question|
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
