# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'depends'
require 'test/unit'

class TestDependency < Test::Unit::TestCase
  # '>=' な relation のテスト
  public
  def test_relation_ge
    depends = Depends::Dependency.new( 'q-bert (>= 1.0)' )
    
    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '1.0',    depends.version, 'version 属性が正しくない' )

    # == 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: >=)' )

    # > 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( depends.relation.call( package ), '依存関係が正しくない (バージョン指定: >=)' )

    # < 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( !depends.relation.call( package ), '依存関係が正しくない (バージョン指定: >=)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 1.0
STATUS
    assert( !depends.relation.call( package ), '依存関係が正しくない (バージョン指定: >=)' )
  end

  # '>>' な relation のテスト
  public
  def test_relation_gt
    depends = Depends::Dependency.new( 'q-bert (>> 1.0)' )

    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '1.0',    depends.version, 'version 属性が正しくない' )

    # == 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: >>)' )

    # > 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: >>)' )

    # < 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: >>)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 1.1
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: >>)' )
  end

  # '<=' な relation のテスト
  public
  def test_relation_le
    depends = Depends::Dependency.new( 'q-bert (<= 1.0)' )
    
    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '1.0',    depends.version, 'version 属性が正しくない' )

    # == 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: <=)' )

    # < 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: <=)' )

    # > 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: <=)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 1.0
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: <=)' )
  end

  # '<<' な relation のテスト
  public
  def test_relation_lt
    depends = Depends::Dependency.new( 'q-bert (<< 1.0)' )

    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '1.0',    depends.version, 'version 属性が正しくない' )

    # == 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: <<)' )

    # < 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: <<)' )

    # > 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: <<)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 0.9
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: <<)' )
  end

  # '=' な relation のテスト
  public
  def test_relation_eql
    depends = Depends::Dependency.new( 'q-bert (= 1.0)' )

    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '1.0',    depends.version, 'version 属性が正しくない' )

    # == 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定: =)' )

    # < 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: =)' )

    # > 1.0 (fail)
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: =)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 1.0
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定: =)' )
  end

  # バージョンが指定されていない relation のテスト
  public
  def test_relation_noversion
    depends = Depends::Dependency.new( 'q-bert' )

    assert_equal( 'q-bert', depends.name,    'name 属性が正しくない' )
    assert_equal( '*',      depends.version, 'version 属性が正しくない' )

    # == 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.0
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定無し)' )

    # < 1.0
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 0.9
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定無し)' )

    # > 1.0 
    package = Depends::Package.new(<<STATUS)
Package: q-bert
Version: 1.1
STATUS
    assert( depends.relation.call(package), '依存関係が正しくない (バージョン指定無し)' )

    # パッケージ名が異なる (fail)
    package = Depends::Package.new(<<STATUS)
Package: d-styles
Version: 1.0
STATUS
    assert( !depends.relation.call(package), '依存関係が正しくない (バージョン指定無し)' )
  end

  public
  def test_exception
    assert_raises( Depends::Exception::UnknownDependencyException,
                   'UnknownDependencyException 例外が発生しなかった' ) do
      Depends::Dependency.new( 'WRONG DEPENDENCY STRING' )
    end
  end

  public
  def test_inspect
    depends = Depends::Dependency.new( 'cpp (>= 4:3.3.2-2)' )
    assert_equal( '<Dependency: cpp (>= 4:3.3.2-2)>', depends.inspect, 'inspect 文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
