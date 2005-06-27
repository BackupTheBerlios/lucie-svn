# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift '../../lib'

require 'depends'
require 'test/unit'

class TC_Pool < Test::Unit::TestCase
  public
  def test_package
    pool = Depends::Pool.new
    package = pool.package('ruby')
    assert_kind_of Depends::Package, package
    assert_equal 'ruby', package.name
  end

  public
  def test_new
    pool = Depends::Pool.new
    assert_kind_of Depends::Pool, pool
  end

  public
  def test_conflict?
    # conflict しない場合
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed

Package: b
Status: install ok installed
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b

Package: b
Status: install ok installed
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # conflict しない場合、バージョン指定あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (= 1.0)

Package: b
Status: install ok installed
Version: 1.1    
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合、バージョン指定あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (= 1.0)

Package: b
Status: install ok installed
Version: 1.0
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # conflict しない場合、バージョン指定 (>>) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (>> 1.0)

Package: b
Status: install ok installed
Version: 1.0
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合、バージョン指定 (>>) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (>> 1.0)

Package: b
Status: install ok installed
Version: 1.1
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # conflict しない場合、バージョン指定 (>=) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (>= 1.0)

Package: b
Status: install ok installed
Version: 0.9
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合、バージョン指定 (>=) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (>= 1.0)

Package: b
Status: install ok installed
Version: 1.0
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # conflict しない場合、バージョン指定 (<<) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (<< 1.0)

Package: b
Status: install ok installed
Version: 1.0
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合、バージョン指定 (<<) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (<< 1.0)

Package: b
Status: install ok installed
Version: 0.9
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # conflict しない場合、バージョン指定 (<=) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (<= 1.0)

Package: b
Status: install ok installed
Version: 1.1
STATUS
    assert_equal false, pool.conflict?('a', 'b')

    # conflict する場合、バージョン指定 (<=) あり。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Conflicts: b (<= 1.0)

Package: b
Status: install ok installed
Version: 1.0
STATUS
    assert_equal true, pool.conflict?('a', 'b')

    # 指定されたパッケージがみつからない場合。
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
STATUS
    assert_raises( Depends::Exception::UnknownPackageException ) { pool.conflict?('a', 'b') }

    # 指定されたパッケージがみつからない場合。
    pool = Depends::Pool.new(<<STATUS)
Package: b
Status: install ok installed
STATUS
    assert_raises( Depends::Exception::UnknownPackageException ) { pool.conflict?('a', 'b') }
  end


  public
  def test_conflicts
    pool = Depends::Pool.new(<<STATUS)
Package: gcc-2.95
Status: install ok installed
Conflicts: libc5-dev, egcc (<< 2.91.63-1.1)

Package: bar
Status: install ok installed
    assert_equal '[<Dependency: libc5-dev>, <Dependency: egcc (<< 2.91.63-1.1)>]',  pool.conflicts( 'gcc-2.95' ).inspect

    assert_raises( RuntimeError ) { pool.conflicts( 'foo' ) }
    assert_equal [], pool.conflicts( 'bar' )
  end


  public
  def test_deps
    # forward dependency のテスト
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Depends: b, c

Package: b
Status: install ok installed
Depends: d

Package: c
Status: install ok installed

Package: d
Status: install ok installed
Depends: e

Package: e
Status: install ok installed
STATUS
    deps = pool.deps('a', 1)
    assert_equal 2, deps[:forward].size
    assert_equal 'b', deps[:forward][0].name
    assert_equal 'c', deps[:forward][1].name

    deps = pool.deps('a', 2)
    assert_equal 3, deps[:forward].size
    assert_equal 'b', deps[:forward][0].name
    assert_equal 'c', deps[:forward][1].name
    assert_equal 'd', deps[:forward][2].name

    deps = pool.deps('a', 3)
    assert_equal 4, deps[:forward].size
    assert_equal 'b', deps[:forward][0].name
    assert_equal 'c', deps[:forward][1].name
    assert_equal 'd', deps[:forward][2].name
    assert_equal 'e', deps[:forward][3].name
    
    deps = pool.deps('c', 1)
    assert_equal [], deps[:forward]


    # reverse dependency のテスト
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Depends: b, c

Package: b
Status: install ok installed
Depends: d

Package: c
Status: install ok installed

Package: d
Status: install ok installed
Depends: e

Package: e
Status: install ok installed

Package: f
Status: install ok installed
Depends: e
STATUS

    deps = pool.deps('e', 1)
    assert_equal 2, deps[:reverse].size
    assert_equal 'd', deps[:reverse][0].name
    assert_equal 'f', deps[:reverse][1].name

    deps = pool.deps('e', 2)
    assert_equal 3, deps[:reverse].size
    assert_equal 'd', deps[:reverse][0].name
    assert_equal 'b', deps[:reverse][1].name
    assert_equal 'f', deps[:reverse][2].name

    deps = pool.deps('e', 3)
    assert_equal 4, deps[:reverse].size
    assert_equal 'd', deps[:reverse][0].name
    assert_equal 'b', deps[:reverse][1].name
    assert_equal 'a', deps[:reverse][2].name
    assert_equal 'f', deps[:reverse][3].name

    deps = pool.deps('a', 1)
    assert_equal [], deps[:reverse]


    # reverse dependency のテスト
    pool = Depends::Pool.new(<<STATUS)
Package: a
Status: install ok installed
Depends: b, c

Package: b
Status: install ok installed
Depends: d

Package: c
Status: install ok installed

Package: d
Status: install ok installed
Depends: e-werk

Package: e
Status: install ok installed
Provides: e-werk

Package: f
Status: install ok installed
Depends: e-werk
STATUS

    deps = pool.deps('e', 1)
    assert_equal 2, deps[:provided].size
    assert_equal 'd', deps[:provided][0].name
    assert_equal 'f', deps[:provided][1].name

    deps = pool.deps('e', 2)
    assert_equal 3, deps[:provided].size
    assert_equal 'd', deps[:provided][0].name
    assert_equal 'b', deps[:provided][1].name
    assert_equal 'f', deps[:provided][2].name

    deps = pool.deps('e', 3)
    assert_equal 4, deps[:provided].size
    assert_equal 'd', deps[:provided][0].name
    assert_equal 'b', deps[:provided][1].name
    assert_equal 'a', deps[:provided][2].name
    assert_equal 'f', deps[:provided][3].name

    deps = pool.deps('a', 1)
    assert_equal [], deps[:provided]
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
