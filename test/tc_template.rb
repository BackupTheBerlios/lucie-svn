#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def setup
    @template = Lucie::Template.new( test_template_data )
  end
  
  # パーズ結果のテンプレート数が合っているかテスト
  public
  def test_size_of_templates
    assert_equal 4, @template.size
  end
  
  # テンプレート 'libdebconf-client-ruby/do_you_like_ruby' の各値が正しく取得できるかテスト
  public
  def test_template_do_you_like_ruby
    do_you_like_ruby = @template['libdebconf-client-ruby/do_you_like_ruby']
    assert_kind_of Hash, do_you_like_ruby, "テンプレートが Hash として取得できない"    
    assert_equal 'libdebconf-client-ruby/do_you_like_ruby', do_you_like_ruby['Template'], "Template: の値が違う"
    assert_equal 'boolean', do_you_like_ruby['Type'], "Type: の値が違う"
    assert_equal 'yes', do_you_like_ruby['Default'], "Default: の値が違う"
    assert_equal "Do you like Ruby?\nRuby is an object oriented scripting language.", do_you_like_ruby['Description'], "Description: の値が違う"
    assert_equal "Ruby は好きですか?\nRuby はオブジェクト指向のスクリプト言語です。", do_you_like_ruby['Description-ja'], "Description-ja: の値が違う"
  end
  
  # テンプレート 'libdebconf-client-ruby/hello_world' の各値が正しく取得できるかテスト
  public
  def test_hello_world
    hello_world = @template['libdebconf-client-ruby/hello_world']
    assert_kind_of Hash, hello_world, "テンプレートが Hash として取得できない"
    assert_equal 'libdebconf-client-ruby/hello_world', hello_world['Template'], "Template: の値が違う"
    assert_equal 'note', hello_world['Type'], "Type: の値が違う"
    assert_equal "Hello, World\nThis is an example script of libdebconf-client-ruby. You will see some\nexample questions from a Ruby script and find how to use the library and\nwhat this library does.", hello_world['Description'], "Description: の値が違う"
    assert_equal "ようこそ\nこれは libdebconf-client-ruby のサンプルスクリプトです.\nこれから Ruby スクリプトから,\nいくつかの質問を聞かれますので, このライブラリの\n使い方や, そもそも,\nこれがいったい何なのかわかるでしょう。", hello_world['Description-ja'], "Description-ja: の値が違う"
  end
  
  # 境界条件として、一番最後に定義されたテンプレートの 'libdebconf-client-ruby/nice_guy' の各値が正しく取得できるかテスト
  public
  def test_nice_guy
    nice_guy = @template['libdebconf-client-ruby/nice_guy']
    assert_kind_of Hash, nice_guy, "テンプレートが Hash として取得できない"
    assert_equal 'libdebconf-client-ruby/nice_guy', nice_guy['Template'], "Template: の値が違う"
    assert_equal 'note', nice_guy['Type'], "Type: の値が違う"
    assert_equal "You nice Guy!\nGood Answer! You may be a nice guy.", nice_guy['Description'], 'Description の値が違う'
    assert_equal "さすが!\nさすがです! きっと、かっこいいお兄さんですね?", nice_guy['Description-ja'], 'Description-ja の値が違う'
  end
  
  # templates.ja の例は libdebconf-client-ruby から抜粋
  private
  def test_template_data
    return (<<-TEMPLATE)
Template: libdebconf-client-ruby/do_you_like_ruby
Type: boolean
Default: yes
Description: Do you like Ruby?
 Ruby is an object oriented scripting language.
Description-ja: Ruby は好きですか?
 Ruby はオブジェクト指向のスクリプト言語です。

Template: libdebconf-client-ruby/hello_world
Type: note
Description: Hello, World
 This is an example script of libdebconf-client-ruby. You will see some
 example questions from a Ruby script and find how to use the library and
 what this library does.
Description-ja: ようこそ
 これは libdebconf-client-ruby のサンプルスクリプトです.
 これから Ruby スクリプトから,
 いくつかの質問を聞かれますので, このライブラリの
 使い方や, そもそも,
 これがいったい何なのかわかるでしょう。

Template: libdebconf-client-ruby/bad_man
Type: note
Description: Why? You should try to like Ruby.
 You can't finish this question until you like Ruby.  
Description-ja: む? Ruby を好きになりなさい!
 Ruby が好きになるまで, この質問を終了することはできません。 

Template: libdebconf-client-ruby/nice_guy
Type: note
Description: You nice Guy!
 Good Answer! You may be a nice guy.
Description-ja: さすが!
 さすがです! きっと、かっこいいお兄さんですね?
    TEMPLATE
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: