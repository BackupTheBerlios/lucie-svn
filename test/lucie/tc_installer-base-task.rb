#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rake'
require 'lucie/installer-base-task'
require 'test/unit'

class TC_InstallerBaseTask < Test::Unit::TestCase
  public
  def setup
    Task.clear    
  end
  
  public
  def teardown 
    Task.clear
  end
  
  public
  def test_default_attributes
    installer_base_task = Rake::InstallerBaseTask.new
    assert_equal( :installer_base, installer_base_task.name )
    assert_equal( '/var/lib/lucie/installer-base/', 
                  installer_base_task.directory )
    assert_nil( installer_base_task.distribution )
    assert_nil( installer_base_task.distribution_version )
  end
  
  public
  def test_task_name
    installer_base_task = Rake::InstallerBaseTask.new( :woody_base )
    assert_equal( :woody_base, installer_base_task.name )
  end
  
  public
  def test_accessor
    installer_base_task = Rake::InstallerBaseTask.new do |task|
      task.directory = 'tmp'
      task.distribution = 'debian'
      task.distribution_version = 'sarge'
    end
    assert_equal( :installer_base, installer_base_task.name )
    assert_equal( 'tmp', installer_base_task.directory )
    assert_equal( 'debian', installer_base_task.distribution )
    assert_equal( 'sarge', installer_base_task.distribution_version )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: