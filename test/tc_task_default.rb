#
# $Id: tc_setup.rb 21 2005-02-01 07:08:41Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 21 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/rake/default'
require 'test/unit'

class TC_Task_Default < Test::Unit::TestCase
  public
  def test_default_task_defined_and_prerequisites
    assert_equal ['installer_template'], default_task.prerequisites, 'default タスクの Prerequisites が正しくない'
  end
  
  private
  def default_task
    fail 'default タスクが定義されていない' unless Task::task_defined?( 'default' )
    return Task::lookup( 'default' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
