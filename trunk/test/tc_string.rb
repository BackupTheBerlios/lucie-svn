#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/string'
require 'test/unit'

class TC_String < Test::Unit::TestCase
  # ソースコードが左寄せになることを確認
  public
  def test_unindent_auto
    assert_equal( (<<-EXPECTED_SOURCE_CODE), (<<-TEST_SOURCE_CODE).unindent_auto, "正しくアンインデント(オート)できない" )
class Test
  public
  def this_is_da_test
    puts "HELLO"
  end
end
    EXPECTED_SOURCE_CODE
    class Test
      public
      def this_is_da_test
        puts "HELLO"
      end
    end
    TEST_SOURCE_CODE
  end
  
  # スペース -> タブのテスト
  public
  def test_tabify
    assert_equal "\t ABCDE", '         ABCDE'.tabify, '正しくタビファイできない'
  end
  
  # タブ -> スペースのテスト
  public
  def test_untabify_tabstop_default
    assert_equal '        ABCDE', "\tABCDE".untabify, '正しくアンタビファイできない'
  end
  
  # タブ -> スペースのテスト (タブストップを変えて)
  public
  def test_untabify_tabstop_4
    assert_equal '    ABCDE', "\tABCDE".untabify( 4 ), '正しくアンタビファイできない'
  end
  
  # タブ -> スペースのテスト (凝った例)
  public
  def test_untabify_complicated_string
    assert_equal 'ABCDE   FGHIJK  LMN', "ABCDE\tFGHIJK\tLMN".untabify( 4 ), '正しくアンタビファイできない'
  end
  
  # アンインデントしても変わらず
  public
  def test_unindent_0
    assert_equal 'ABCDE', 'ABCDE'.unindent(0), "正しくアンインデントされていない"
  end
  
  # アンインデントしても変わらず (複数行)
  public
  def test_unindent_0_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_0), (<<-TEST_STRING_UNINDENT_0).unindent(0), "正しくアンインデントされていない"
 ABCDE
 FGHIJ
 KLMNO
    EXPECTED_STRING_UNINDENT_0
 ABCDE
 FGHIJ
 KLMNO
    TEST_STRING_UNINDENT_0
  end
  
  # 4 つアンインデント
  public
  def test_unindent_4
    assert_equal ' ABCDE', '     ABCDE'.unindent(4), "正しくアンインデントされていない"
  end
  
  # 4 つアンインデント (複数行)
  public
  def test_unindent_4_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_4), (<<-TEST_STRING_UNINDENT_4).unindent(4), "正しくアンインデントされていない"
  ABCDE
FGHIJ
  KLMNO    
    EXPECTED_STRING_UNINDENT_4
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING_UNINDENT_4
  end
  
  # タブを含めて 3 つアンインデント 
  public
  def test_unindent_with_tab
    assert_equal "      ABCDE", "\t ABCDE".unindent(3), "正しくアンインデントされていない"
  end
  
  # タブを含めて 3 つアンインデント (複数行) 
  public
  def test_unindent_with_tab_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_WITH_TAB), (<<-TEST_STRING_UNINDENT_WITH_TAB).unindent(3), "正しくアンインデントされていない"
       ABCDE
     FGHIJ
       KLMNO    
    EXPECTED_STRING_UNINDENT_WITH_TAB
\t  ABCDE
\tFGHIJ
\t  KLMNO    
    TEST_STRING_UNINDENT_WITH_TAB
  end
  
  # 頭に空白がないため、minimum_indent は 0
  public
  def test_minimum_indent_0
    assert_equal 0, 'ABCDE'.minimum_indent, "minimum_indent の値がおかしい"
  end
  
  # 頭に空白がないため、minimum_indent は 0 (複数行)
  public
  def test_minimum_indent_0_multiple_lines
    assert_equal 0, (<<-TEST_STRING_MINIMUM_INDENT_0).minimum_indent, "minimum_indent の値がおかしい"
ABCDE
FGHIJ
KLMNO
    TEST_STRING_MINIMUM_INDENT_0
  end
  
  # 頭に空白が 4 つあるので、minimum_indent は 4
  public
  def test_minimum_indent_4
    assert_equal 4, '    ABCDE'.minimum_indent, "minimum_indent の値がおかしい"
  end
  
  # 頭に空白が 4 つあるので、minimum_indent は 4 (複数行)
  public
  def test_minimum_indent_4_multiple_lines
    assert_equal 4, (<<-TEST_STRING_MINIMUM_INDENT_4).minimum_indent, "minimum_indent の値がおかしい"
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING_MINIMUM_INDENT_4
  end
  
  # タブストップ 8 なので、頭にタブがあった場合 minimum_indent は 8
  public
  def test_minimum_indent_8
    assert_equal 8, "\tABCDE".minimum_indent, "minimum_indent の値がおかしい"
  end
  
  # タブストップ 8 なので、頭にタブがあった場合 minimum_indent は 8 (複数行)
  public
  def test_minimum_indent_8_multiple_lines
    assert_equal 8, (<<-TEST_STRING_MINIMUM_INDENT_8).minimum_indent, "minimum_indent の値がおかしい"
\t\tABCDE
\tFGHIJ
\t\tKLMNO
    TEST_STRING_MINIMUM_INDENT_8
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: