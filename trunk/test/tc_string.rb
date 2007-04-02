#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


$LOAD_PATH.unshift './lib'


require 'lucie/string'
require 'test/unit'


class TC_String < Test::Unit::TestCase
  def test_to_rfc822
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).to_rfc822, 'String#to_rfc822 ���������l��Ԃ��Ȃ�' )
 foo
 .
 bar
 .
 baz
    EXPECTED_STRING
foo

bar

baz
    TEST_STRING
  end


  def test_to_pascal_style
    assert_equal 'Foo', 'foo'.to_pascal_style, 'String#to_pascal_style ���������l��Ԃ��Ȃ�'
  end


  def test_to_pascal_style_with_underbar
    assert_equal 'FooBarBaz', 'foo_bar_baz'.to_pascal_style, 'String#to_pascal_style ���������l��Ԃ��Ȃ�'
  end


  # �\�[�X�R�[�h�����񂹂ɂȂ邱�Ƃ��m�F
  def test_unindent_auto
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent_auto, "������ unindent_auto �ł��Ȃ�" )
class Test
  public
  def this_is_da_test
    puts "HELLO"
  end
end
    EXPECTED_STRING
    class Test
      public
      def this_is_da_test
        puts "HELLO"
      end
    end
    TEST_STRING
  end


  def test_indent
    assert_equal ' 0123', '0123'.indent( 1 )
  end


  def test_indent_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).indent( 4 ), "������ indent �ł��Ȃ�" )
    class Test
      public
      def this_is_da_test
        puts "HELLO"
      end
    end
    EXPECTED_STRING
class Test
  public
  def this_is_da_test
    puts "HELLO"
  end
end
    TEST_STRING
  end


  # �X�y�[�X -> �^�u�̃e�X�g
  def test_tabify
    assert_equal "\t ABCDE", '         ABCDE'.tabify, '������ tabify �ł��Ȃ�'
  end


  # �^�u -> �X�y�[�X�̃e�X�g
  def test_untabify_tabstop_default
    assert_equal '        ABCDE', "\tABCDE".untabify, '������ untabify �ł��Ȃ�'
  end


  # �^�u -> �X�y�[�X�̃e�X�g (�^�u�X�g�b�v��ς���)
  def test_untabify_tabstop_4
    assert_equal '    ABCDE', "\tABCDE".untabify( 4 ), '������ untabify �ł��Ȃ�'
  end


  # �^�u -> �X�y�[�X�̃e�X�g (�Â�����)
  def test_untabify_complicated_string
    assert_equal 'ABCDE   FGHIJK  LMN', "ABCDE\tFGHIJK\tLMN".untabify( 4 ), '������ untabify �ł��Ȃ�'
  end


  # �A���C���f���g���Ă��ς�炸
  def test_unindent_0
    assert_equal 'ABCDE', 'ABCDE'.unindent( 0 ), "������ unindent ����Ă��Ȃ�"
  end


  # �A���C���f���g���Ă��ς�炸
  def test_unindent_0_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 0 ), "������ unindent ����Ă��Ȃ�" )
 ABCDE
 FGHIJ
 KLMNO
    EXPECTED_STRING
 ABCDE
 FGHIJ
 KLMNO
    TEST_STRING
  end


  # 4 �A���C���f���g
  def test_unindent_4
    assert_equal ' ABCDE', '     ABCDE'.unindent( 4 ), "������ unindent ����Ă��Ȃ�"
  end


  # 4 �A���C���f���g
  def test_unindent_4_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 4 ), "�������A���C���f���g����Ă��Ȃ�" )
  ABCDE
FGHIJ
  KLMNO
    EXPECTED_STRING
      ABCDE
    FGHIJ
      KLMNO
    TEST_STRING
  end


  # �^�u���܂߂� 3 �A���C���f���g
  def test_unindent_with_tab
    assert_equal "      ABCDE", "\t ABCDE".unindent( 3 ), "������ unindent ����Ă��Ȃ�"
  end


  # �^�u���܂߂� 3 �A���C���f���g
  def test_unindent_with_tab_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 3 ), "������ unindent ����Ă��Ȃ�" )
       ABCDE
     FGHIJ
       KLMNO
    EXPECTED_STRING
\t  ABCDE
\tFGHIJ
\t  KLMNO
    TEST_STRING
  end


  # ���ɋ󔒂��Ȃ����߁Aminimum_indent �� 0
  def test_minimum_indent_0
    assert_equal 0, 'ABCDE'.minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
  end


  # ���ɋ󔒂��Ȃ����߁Aminimum_indent �� 0
  def test_minimum_indent_0_multiple_lines
    assert_equal 0, ( <<-TEST_STRING ).minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
ABCDE
FGHIJ
KLMNO
    TEST_STRING
  end


  # ���ɋ󔒂� 4 ����̂ŁAminimum_indent �� 4
  def test_minimum_indent_4
    assert_equal 4, '    ABCDE'.minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
  end


  # ���ɋ󔒂� 4 ����̂ŁAminimum_indent �� 4
  def test_minimum_indent_4_multiple_lines
    assert_equal 4, ( <<-TEST_STRING ).minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING
  end


  # �^�u�X�g�b�v 8 �Ȃ̂ŁAminimum_indent �� 8
  def test_minimum_indent_8
    assert_equal 8, "\tABCDE".minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
  end


  # �^�u�X�g�b�v 8 �Ȃ̂ŁAminimum_indent �� 8
  def test_minimum_indent_8_multiple_lines
    assert_equal 8, ( <<-TEST_STRING ).minimum_indent, "minimum_indent �̕Ԃ��l���������Ȃ�"
\t\tABCDE
\tFGHIJ
\t\tKLMNO
    TEST_STRING
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
