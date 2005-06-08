# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift '../../lib'

require 'depends'
require 'test/unit'

class TC_Cache < Test::Unit::TestCase
  public
  def teardown
    File.delete( cache_filepath ) if FileTest.file?( cache_filepath )
  end

  public
  def test_object_pool_cache
    assert_kind_of Depends::Pool, get_pool # not cached
    assert_kind_of Depends::Pool, get_pool # cached
  end

  public
  def test_inspect
    cache = Depends::Cache.new( cache_directory, cache_filename )
    assert_equal "<Cache: cachefile='#{cache_filepath}'>", cache.inspect
  end
  
  private
  def get_pool
    Depends::Cache.new( cache_directory, cache_filename ).pool
  end

  private 
  def cache_filepath
    File.join( cache_directory, cache_filename )
  end

  private
  def cache_directory
    '/tmp'
  end

  private
  def cache_filename
    'tc_cache.cache'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
