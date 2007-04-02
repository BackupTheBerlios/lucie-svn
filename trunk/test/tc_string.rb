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
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).to_rfc822, 'String#to_rfc822 が正しい値を返さない' )
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
    assert_equal 'Foo', 'foo'.to_pascal_style, 'String#to_pascal_style が正しい値を返さない'
  end


  def test_to_pascal_style_with_underbar
    assert_equal 'FooBarBaz', 'foo_bar_baz'.to_pascal_style, 'String#to_pascal_style が正しい値を返さない'
  end


  # ソースコードが左寄せになることを確認
  def test_unindent_auto
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent_auto, "正しく unindent_auto できない" )
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
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).indent( 4 ), "正しく indent できない" )
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


  # スペース -> タブのテスト
  def test_tabify
    assert_equal "\t ABCDE", '         ABCDE'.tabify, '正しく tabify できない'
  end


  # タブ -> スペースのテスト
  def test_untabify_tabstop_default
    assert_equal '        ABCDE', "\tABCDE".untabify, '正しく untabify できない'
  end


  # タブ -> スペースのテスト (タブストップを変えて)
  def test_untabify_tabstop_4
    assert_equal '    ABCDE', "\tABCDE".untabify( 4 ), '正しく untabify できない'
  end


  # タブ -> スペースのテスト (凝った例)
  def test_untabify_complicated_string
    assert_equal 'ABCDE   FGHIJK  LMN', "ABCDE\tFGHIJK\tLMN".untabify( 4 ), '正しく untabify できない'
  end


  # アンインデントしても変わらず
  def test_unindent_0
    assert_equal 'ABCDE', 'ABCDE'.unindent( 0 ), "正しく unindent されていない"
  end


  # アンインデントしても変わらず
  def test_unindent_0_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 0 ), "正しく unindent されていない" )
 ABCDE
 FGHIJ
 KLMNO
    EXPECTED_STRING
 ABCDE
 FGHIJ
 KLMNO
    TEST_STRING
  end


  # 4 つアンインデント
  def test_unindent_4
    assert_equal ' ABCDE', '     ABCDE'.unindent( 4 ), "正しく unindent されていない"
  end


  # 4 つアンインデント
  def test_unindent_4_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 4 ), "正しくアンインデントされていない" )
  ABCDE
FGHIJ
  KLMNO
    EXPECTED_STRING
      ABCDE
    FGHIJ
      KLMNO
    TEST_STRING
  end


  # タブを含めて 3 つアンインデント
  def test_unindent_with_tab
    assert_equal "      ABCDE", "\t ABCDE".unindent( 3 ), "正しく unindent されていない"
  end


  # タブを含めて 3 つアンインデント
  def test_unindent_with_tab_multiple_lines
    assert_equal( ( <<-EXPECTED_STRING ), ( <<-TEST_STRING ).unindent( 3 ), "正しく unindent されていない" )
       ABCDE
     FGHIJ
       KLMNO
    EXPECTED_STRING
\t  ABCDE
\tFGHIJ
\t  KLMNO
    TEST_STRING
  end


  # 頭に空白がないため、minimum_indent は 0
  def test_minimum_indent_0
    assert_equal 0, 'ABCDE'.minimum_indent, "minimum_indent の返す値が正しくない"
  end


  # 頭に空白がないため、minimum_indent は 0
  def test_minimum_indent_0_multiple_lines
    assert_equal 0, ( <<-TEST_STRING ).minimum_indent, "minimum_indent の返す値が正しくない"
ABCDE
FGHIJ
KLMNO
    TEST_STRING
  end


  # 頭に空白が 4 つあるので、minimum_indent は 4
  def test_minimum_indent_4
    assert_equal 4, '    ABCDE'.minimum_indent, "minimum_indent の返す値が正しくない"
  end


  # 頭に空白が 4 つあるので、minimum_indent は 4
  def test_minimum_indent_4_multiple_lines
    assert_equal 4, ( <<-TEST_STRING ).minimum_indent, "minimum_indent の返す値が正しくない"
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING
  end


  # タブストップ 8 なので、minimum_indent は 8
  def test_minimum_indent_8
    assert_equal 8, "\tABCDE".minimum_indent, "minimum_indent の返す値が正しくない"
  end


  # タブストップ 8 なので、minimum_indent は 8
  def test_minimum_indent_8_multiple_lines
    assert_equal 8, ( <<-TEST_STRING ).minimum_indent, "minimum_indent の返す値が正しくない"
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
