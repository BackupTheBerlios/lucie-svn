#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/lmp-package-task'
require 'test/unit'

class TC_LMPPackageTask < Test::Unit::TestCase
  public
  def test_lmp_spec_getter
    lmp_spec = Mock.new( '[LMP SPECIFICATION]' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :files ) do [] end
    lmp_spec.__next( :files ) do [] end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    assert_equal( lmp_spec, lmp_package_task.lmp_spec, 'lmp_spec �� getter ����������' ) 
    lmp_spec.__verify
  end
  
  public
  def test_define_tasks
    lmp_spec = Mock.new( '[LMP SPECIFICATION]' )
    lmp_spec.__next( :name ) do 'LMP-TEST' end
    lmp_spec.__next( :version ) do '0.0.1' end
    lmp_spec.__next( :files ) do [] end
    lmp_spec.__next( :files ) do [] end
    lmp_spec.__next( :files ) do [] end
    
    lmp_package_task = Rake::LMPPackageTask.new( lmp_spec )
    lmp_package_task.define
    
    assert( Task.task_defined?( :package ), ':package �^�X�N����`����Ă��Ȃ�' )
    assert_equal( ['lmp'], Task[:package].prerequisites, ':package �^�X�N�� prerequisites ���������Ȃ�' )
    assert( Task.task_defined?( :lmp ), ':lmp �^�X�N����`����Ă��Ȃ�' )
    assert_equal( ['pkg/LMP-TEST_0.0.1_all.deb'], Task[:lmp].prerequisites, ':lmp �^�X�N�� prerequisites ���������Ȃ�' )
    assert( Task.task_defined?( 'pkg/LMP-TEST_0.0.1_all.deb' ), "'pkg/LMP-TEST_0.0.1_all.deb' �^�X�N����`����Ă��Ȃ�" )
    lmp_spec.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: