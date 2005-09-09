#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$trace = true
$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/specification'
require 'lmp/lmp-package-task'
require 'test/unit'

class TC_LMPPackageTask < Test::Unit::TestCase
  public
  def test_lmp_spec_getter
    lmp_spec = Mock.new( '#<Specification (Mock)>' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :files ) do files end 
    lmp_spec.__next( :files ) do files end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    assert_equal( lmp_spec, lmp_package_task.lmp_spec ) 
    lmp_spec.__verify
  end
  
  public
  def test_define_tasks
    lmp_spec = Mock.new( '#<Specification (Mock)>' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :architecture ) do files end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :architecture ) do 'all' end
    lmp_spec.__next( :architecture ) do 'all' end
    lmp_spec.__next( :files ) do files end
    lmp_spec.__next( :architecture ) do 'all' end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    lmp_package_task.define
    
    assert( Task.task_defined?( :package ) )
    assert_equal( ['lmp'], Task[:package].prerequisites )
    assert( Task.task_defined?( :lmp ) )
    assert_equal( ['pkg/LMP-TEST_0.0.1_all.deb'], Task[:lmp].prerequisites )
    assert( Task.task_defined?( 'pkg/LMP-TEST_0.0.1_all.deb' ) )
    assert_equal( ['pkg/debian'] + files.map do |each| "pkg/#{each}" end, Task['pkg/LMP-TEST_0.0.1_all.deb'].prerequisites )
    lmp_spec.__verify
  end
  
  private
  def files
    return ['debian/README.Debian', 
             'debian/changelog', 
             'debian/config', 
             'debian/control', 
             'debian/copyright',
             'debian/postinst',
             'debian/rules',
             'debian/templates',
             'packages'] 
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
