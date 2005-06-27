# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'depends'
require 'test/unit'

class TC_Cache < Test::Unit::TestCase
  # �ƥ�������������줿����å���ե������õ�
  public
  def teardown
    File.delete( cache_filepath ) if FileTest.file?( cache_filepath )
  end

  # Cache ���饹��ͳ�� Pool ���󥹥��󥹤�����Ǥ��뤳�Ȥ��ǧ
  public
  def test_pool_cache
    assert_kind_of( Depends::Pool, get_pool, 'Pool ���֥������Ȥ� Cache ��������Ǥ��ʤ�' ) # not cached
    assert_kind_of( Depends::Pool, get_pool, 'Pool ���֥������Ȥ� Cache ��������Ǥ��ʤ�' ) # cached
  end

  # inspect �᥽�åɤη�̤�ƥ���
  public
  def test_inspect
    cache = Depends::Cache.new( cache_directory, cache_filename )
    assert_equal( %{<Cache: cachefile='#{cache_filepath}'>}, cache.inspect, 'inspect ���֤��ͤ��������ʤ�' )
  end
  
  private
  def get_pool
    return Depends::Cache.new( cache_directory, cache_filename ).pool
  end

  private 
  def cache_filepath
    return File.join( cache_directory, cache_filename )
  end

  private
  def cache_directory
    return '/tmp'
  end

  private
  def cache_filename
    return 'tc_cache.cache'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
