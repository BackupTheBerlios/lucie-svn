#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/builder'
require 'test/unit'

class TC_Builder < Test::Unit::TestCase
  public
  def test_all_file_tasks_defined
    lmp_spec = Mock.new( '#<Specification (Mock)>' )
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    lmp_spec.__next( :builddir ) do '.' end
    
    builder = LMP::Builder.new( lmp_spec )
    assert_file_task_defined( './debian/README.Debian' )
    assert_file_task_defined( "./debian/changelog" )
    assert_file_task_defined( "./debian/config" )
    assert_file_task_defined( "./debian/control" )
    assert_file_task_defined( "./debian/copyright" )
    assert_file_task_defined( "./debian/postinst" )
    assert_file_task_defined( "./debian/rules" )
    assert_file_task_defined( "./debian/templates" )
    assert_file_task_defined( "./packages" )
  end
  
  private
  def assert_file_task_defined( filePathString )
    assert( Task.task_defined?( filePathString ), "ファイル `#{filePathString}' のタスクが define されていない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
