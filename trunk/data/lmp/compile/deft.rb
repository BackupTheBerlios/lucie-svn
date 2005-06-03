#
# $Id$
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/compile/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-compile setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup packages for developing software.
  DESCRIPTION
  template.short_description_ja = 'lmp-compile ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ᥿�ѥå������ϳ�ȯ�ѥ��եȥ������������ Lucie �����ФعԤ��ޤ���
  ���Υ᥿�ѥå������ˤ�äƥ��饹���Ρ��ɤ˥��󥹥ȡ��뤵���ѥå������ΰ����ϰʲ����̤�Ǥ���

   o electric-fence: malloc(3) �ǥХå�
   o bin86: 16 �ӥåȤΥ�����֥�ȥ���
   o m4: �ޥ����������
   o g77: GNU Fortran 77����ѥ���
   o byacc: The Berkeley LALR parser generator
   o cvs: ��Ʊ��Ȳ�ǽ�ʥС��������������ƥ�
   o ddd: Data Display Debugger - ����ե�����ʥǥХå��ե��ȥ����
   o indent: C ���쥽���������������ץ����
   o autoconf: configure ������ץȼ�ư�����ġ���
   o automake1.8: A tool for generating GNU Standards-compliant Makefiles
   o binutils: GNU ������֥顢��󥫡��Х��ʥ�桼�ƥ���ƥ�
   o bison: yacc �ȸߴ����Τ���ѡ��������ͥ졼��
   o flex: ��®�ʹ�ʸ���ϴ������ץ����
   o cpp: GNU C �ץ�ץ��å�
   o cutils: C �������������ѥ桼�ƥ���ƥ���
   o cxref: C �ץ�����Ѥ� LaTex �� HTML �ɥ�����������ץ����
   o g++: GNU C++ ����ѥ���
   o gcc: GNU C����ѥ���
   o gdb: GNU �ǥХå�
   o glibc-doc: GNU C �饤�֥��ɥ������
   o libtool: ���ѤΥ饤�֥�ꥵ�ݡ��ȥ�����ץ�
   o ltrace: �ץ�����ưŪ�˥�󥯤�����󥿥���饤�֥�ꥳ���������
   o make: GNU �С������� "make" �桼�ƥ���ƥ�
   o manpages-dev: GNU/Linux ��ȯ�Ը����Υޥ˥奢��ڡ���
   o patch: diff �ե�����򥪥ꥸ�ʥ�Υե������Ŭ�Ѥ���
   o stl-manual: C++ ����� STL �饤�֥��ˤĤ��Ƥ� HTML �ɥ������
   o strace: �����ƥॳ�������ץġ���
  DESCRIPTION_JA
end

question( 'lucie-client/compile/hello' => 'lucie-client/compile/g77' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- g77 �ΥС����������

template( 'lucie-client/compile/g77' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default g77 version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default g77 compiler?
  DESCRIPTION
  template.short_description_ja = '�ǥե���� g77 �С�����������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ǥե���ȤȤ��� g77 ����ѥ���ΤɤΥС�������Ȥ��ޤ��� ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/g77' => 'lucie-client/compile/cpp' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- cpp �ΥС����������

template( 'lucie-client/compile/cpp' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default cpp version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default cpp compiler?
  DESCRIPTION
  template.short_description_ja = '�ǥե���� cpp �С�����������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ǥե���ȤȤ��� cpp ����ѥ���ΤɤΥС�������Ȥ��ޤ��� ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/cpp' => 'lucie-client/compile/gpp' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- g++ �ΥС����������

template( 'lucie-client/compile/gpp' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default g++ version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default g++ compiler?
  DESCRIPTION
  template.short_description_ja = '�ǥե���� g++ �С�����������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ǥե���ȤȤ��� g++ ����ѥ���ΤɤΥС�������Ȥ��ޤ��� ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/gpp' => 'lucie-client/compile/gcc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- gcc �ΥС����������

template( 'lucie-client/compile/gcc' ) do |template|
  template.template_type = 'select'
  template.choices = ['2.95', '3.0', '3.2', '3.3', '3.4']
  template.short_description = 'Choice of default gcc version'
  template.extended_description = <<-DESCRIPTION
  Which version do you use for default gcc compiler?
  DESCRIPTION
  template.short_description_ja = '�ǥե���� gcc �С�����������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ǥե���ȤȤ��� gcc ����ѥ���ΤɤΥС�������Ȥ��ޤ��� ?
  DESCRIPTION_JA
end

question( 'lucie-client/compile/gcc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
