#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/boolean-template'
require 'lucie/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def setup
    @templates = Lucie::Template::parse( test_template_data )
  end
  
  ###################################################################################################
  # 定数のテスト
  ###################################################################################################
  
  # MULTISELECT 定数が定義されていることを確認
  public
  def test_const_MULTISELECT_defined  
    assert Lucie::Template.const_defined?( :MULTISELECT ), 'MULTISELECT 定数が定義されていない'
  end
  
  # SELECT 定数が定義されていることを確認
  public
  def test_const_SELECT_defined
    assert Lucie::Template.const_defined?( :SELECT ), 'SELECT 定数が定義されていない'
  end

  ###################################################################################################
  # それ以外のテスト
  ###################################################################################################  

  public
  def test_templates
    Lucie::Template.clear
    template 'TEST/TEMPLATE#1', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#2', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#3', Lucie::BooleanTemplate
    assert_equal 3, Lucie::Template.templates.size
    assert_equal 'TEST/TEMPLATE#1', Lucie::Template.templates[0].name
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[0]
    assert_equal 'TEST/TEMPLATE#2', Lucie::Template.templates[1].name
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[1]
    assert_equal 'TEST/TEMPLATE#3', Lucie::Template.templates[2].name
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[2]
  end

  # 登録されているテンプレートが空のときに、
  # template_defined? が nil を返すことを確認
  public
  def test_template_defined_fail
    Lucie::Template.clear
    assert_nil Lucie::Template.template_defined?( 'NOT DEFINED TEMPLATE' )
  end
  
  # テンプレートを登録し、template_defined? で登録が確認できることをテスト
  public
  def test_template_defined_success
    Lucie::Template.clear
    template( 'TEST TEMPLATE', Lucie::BooleanTemplate )
    assert Lucie::Template.template_defined?( 'TEST TEMPLATE' )
  end
  
  public
  def test_template
    assert_kind_of Lucie::BooleanTemplate, template( 'LUCIE/OVERVIEW', Lucie::BooleanTemplate )
  end
  
  # clear のテスト
  public
  def test_clear
    Lucie::Template::TEMPLATES['TEST TEMPLATE'] = Lucie::Template.new( 'TEST TEMPLATE' )
    Lucie::Template::clear
    assert_equal 0, Lucie::Template::TEMPLATES.size, 'TEMPLATES がクリアされていない'
  end

  # lookup のテスト (未知のテンプレート)
  public
  def test_lookup_unknown_template
    Lucie::Template::clear
    template = Lucie::Template::lookup( 'UNKNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_kind_of Lucie::BooleanTemplate, template
    assert_equal 'UNKNOWN TEMPLATE', template.name, 'テンプレートが登録されていない'
  end
  
  # lookup のテスト (既知のテンプレート)
  public
  def test_lookup_known_template
    Lucie::Template::clear
    template = template( 'KNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_equal template, Lucie::Template::lookup( 'KNOWN TEMPLATE', Lucie::BooleanTemplate ), 'テンプレートが登録されていない'
  end
  
  # パーズ結果のテンプレート数が合っているかテスト
  public
  def test_size_of_templates
    assert_equal 4, @templates.size
  end
  
  # テンプレート 'libdebconf-client-ruby/do_you_like_ruby' の各値が正しく取得できるかテスト
  public
  def test_template_do_you_like_ruby
    do_you_like_ruby = @templates['libdebconf-client-ruby/do_you_like_ruby']
    assert_kind_of Lucie::Template, do_you_like_ruby, "テンプレートが Hash として取得できない"    
    assert_equal 'libdebconf-client-ruby/do_you_like_ruby', do_you_like_ruby['Template'], "Template: の値が違う"
    assert_equal 'boolean', do_you_like_ruby['Type'], "Type: の値が違う"
    assert_equal 'yes', do_you_like_ruby['Default'], "Default: の値が違う"
    assert_equal "Do you like Ruby?\nRuby is an object oriented scripting language.", do_you_like_ruby['Description'], "Description: の値が違う"
    assert_equal "Ruby は好きですか?\nRuby はオブジェクト指向のスクリプト言語です。", do_you_like_ruby['Description-ja'], "Description-ja: の値が違う"
  end
  
  # テンプレート 'libdebconf-client-ruby/hello_world' の各値が正しく取得できるかテスト
  public
  def test_hello_world
    hello_world = @templates['libdebconf-client-ruby/hello_world']
    assert_kind_of Lucie::Template, hello_world, "テンプレートが Hash として取得できない"
    assert_equal 'libdebconf-client-ruby/hello_world', hello_world['Template'], "Template: の値が違う"
    assert_equal 'note', hello_world['Type'], "Type: の値が違う"
    assert_equal "Hello, World\nThis is an example script of libdebconf-client-ruby. You will see some\nexample questions from a Ruby script and find how to use the library and\nwhat this library does.", hello_world['Description'], "Description: の値が違う"
    assert_equal "ようこそ\nこれは libdebconf-client-ruby のサンプルスクリプトです.\nこれから Ruby スクリプトから,\nいくつかの質問を聞かれますので, このライブラリの\n使い方や, そもそも,\nこれがいったい何なのかわかるでしょう。", hello_world['Description-ja'], "Description-ja: の値が違う"
  end
  
  # 境界条件として、一番最後に定義されたテンプレートの 'libdebconf-client-ruby/nice_guy' の各値が正しく取得できるかテスト
  public
  def test_nice_guy
    nice_guy = @templates['libdebconf-client-ruby/nice_guy']
    assert_kind_of Lucie::Template, nice_guy, "テンプレートが Hash として取得できない"
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