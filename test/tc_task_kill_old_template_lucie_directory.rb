#
# $Id: tc_setup.rb 21 2005-02-01 07:08:41Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 21 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rake'
require 'test/unit'

class TC_Task_Kill_Old_Template_Lucie_Directory < Test::Unit::TestCase
  public
  def setup
    Task::clear
    $template_lucie_directory = 'TEMPLATE_LUCIE_DIRECTORY'
    load 'lucie/rake/installer_template.rb'
  end  
  
  public
  def test_kill_old_template_lucie_directory_prerequisites
    assert_equal( 3, task( 'kill_old_template_lucie_directory' ).prerequisites.size,
                  'kill_old_template_lucie_directory タスクの Prerequisites の数が正しくない' )
  end
  
  public
  def test_kill_old_template_lucie_directory_message
    assert_equal( 0, task( 'kill_old_template_lucie_directory_message' ).prerequisites.size, 
                  'kill_old_template_lucie_directory_message タスクの Prerequisites の数が正しくない' )
  end
  
  public
  def test_unmount_pts
    assert_equal( 0, task( 'unmount_pts' ).prerequisites.size, 
                  'unmount_pts タスクの Prerequisites の数が正しくない' )
  end
  
  public
  def test_cleanup_installer_rootfs
      assert_equal( 0, task( 'cleanup_installer_rootfs' ).prerequisites.size, 
                  'cleanup_installer_rootfs タスクの Prerequisites の数が正しくない' )  
  end
  
  private
  def task( taskNameString )
    fail "#{taskNameString} タスクが定義されていない" unless Task::task_defined?( taskNameString )
    return Task::lookup( taskNameString )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
