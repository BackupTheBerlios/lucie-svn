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
  
  # �p�[�Y���ʂ̃e���v���[�g���������Ă��邩�e�X�g
  public
  def test_size_of_templates
    assert_equal 4, @template.size
  end
  
  # �e���v���[�g 'libdebconf-client-ruby/do_you_like_ruby' �̊e�l���������擾�ł��邩�e�X�g
  public
  def test_template_do_you_like_ruby
    do_you_like_ruby = @template['libdebconf-client-ruby/do_you_like_ruby']
    assert_kind_of Hash, do_you_like_ruby, "�e���v���[�g�� Hash �Ƃ��Ď擾�ł��Ȃ�"    
    assert_equal 'libdebconf-client-ruby/do_you_like_ruby', do_you_like_ruby['Template'], "Template: �̒l���Ⴄ"
    assert_equal 'boolean', do_you_like_ruby['Type'], "Type: �̒l���Ⴄ"
    assert_equal 'yes', do_you_like_ruby['Default'], "Default: �̒l���Ⴄ"
    assert_equal "Do you like Ruby?\nRuby is an object oriented scripting language.", do_you_like_ruby['Description'], "Description: �̒l���Ⴄ"
    assert_equal "Ruby �͍D���ł���?\nRuby �̓I�u�W�F�N�g�w���̃X�N���v�g����ł��B", do_you_like_ruby['Description-ja'], "Description-ja: �̒l���Ⴄ"
  end
  
  # �e���v���[�g 'libdebconf-client-ruby/hello_world' �̊e�l���������擾�ł��邩�e�X�g
  public
  def test_hello_world
    hello_world = @template['libdebconf-client-ruby/hello_world']
    assert_kind_of Hash, hello_world, "�e���v���[�g�� Hash �Ƃ��Ď擾�ł��Ȃ�"
    assert_equal 'libdebconf-client-ruby/hello_world', hello_world['Template'], "Template: �̒l���Ⴄ"
    assert_equal 'note', hello_world['Type'], "Type: �̒l���Ⴄ"
    assert_equal "Hello, World\nThis is an example script of libdebconf-client-ruby. You will see some\nexample questions from a Ruby script and find how to use the library and\nwhat this library does.", hello_world['Description'], "Description: �̒l���Ⴄ"
    assert_equal "�悤����\n����� libdebconf-client-ruby �̃T���v���X�N���v�g�ł�.\n���ꂩ�� Ruby �X�N���v�g����,\n�������̎���𕷂���܂��̂�, ���̃��C�u������\n�g������, ��������,\n���ꂪ�����������Ȃ̂��킩��ł��傤�B", hello_world['Description-ja'], "Description-ja: �̒l���Ⴄ"
  end
  
  # ���E�����Ƃ��āA��ԍŌ�ɒ�`���ꂽ�e���v���[�g�� 'libdebconf-client-ruby/nice_guy' �̊e�l���������擾�ł��邩�e�X�g
  public
  def test_nice_guy
    nice_guy = @template['libdebconf-client-ruby/nice_guy']
    assert_kind_of Hash, nice_guy, "�e���v���[�g�� Hash �Ƃ��Ď擾�ł��Ȃ�"
    assert_equal 'libdebconf-client-ruby/nice_guy', nice_guy['Template'], "Template: �̒l���Ⴄ"
    assert_equal 'note', nice_guy['Type'], "Type: �̒l���Ⴄ"
    assert_equal "You nice Guy!\nGood Answer! You may be a nice guy.", nice_guy['Description'], 'Description �̒l���Ⴄ'
    assert_equal "������!\n�������ł�! �����ƁA�������������Z����ł���?", nice_guy['Description-ja'], 'Description-ja �̒l���Ⴄ'
  end
  
  # templates.ja �̗�� libdebconf-client-ruby ���甲��
  private
  def test_template_data
    return (<<-TEMPLATE)
Template: libdebconf-client-ruby/do_you_like_ruby
Type: boolean
Default: yes
Description: Do you like Ruby?
 Ruby is an object oriented scripting language.
Description-ja: Ruby �͍D���ł���?
 Ruby �̓I�u�W�F�N�g�w���̃X�N���v�g����ł��B

Template: libdebconf-client-ruby/hello_world
Type: note
Description: Hello, World
 This is an example script of libdebconf-client-ruby. You will see some
 example questions from a Ruby script and find how to use the library and
 what this library does.
Description-ja: �悤����
 ����� libdebconf-client-ruby �̃T���v���X�N���v�g�ł�.
 ���ꂩ�� Ruby �X�N���v�g����,
 �������̎���𕷂���܂��̂�, ���̃��C�u������
 �g������, ��������,
 ���ꂪ�����������Ȃ̂��킩��ł��傤�B

Template: libdebconf-client-ruby/bad_man
Type: note
Description: Why? You should try to like Ruby.
 You can't finish this question until you like Ruby.  
Description-ja: ��? Ruby ���D���ɂȂ�Ȃ���!
 Ruby ���D���ɂȂ�܂�, ���̎�����I�����邱�Ƃ͂ł��܂���B 

Template: libdebconf-client-ruby/nice_guy
Type: note
Description: You nice Guy!
 Good Answer! You may be a nice guy.
Description-ja: ������!
 �������ł�! �����ƁA�������������Z����ł���?
    TEMPLATE
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: