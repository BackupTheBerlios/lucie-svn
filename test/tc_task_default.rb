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
  def test_default_task_defined
    assert_equal ["make_installer_template"], default_task.prerequisites, "Prerequisites が正しくない"
  end
  
  private
  def default_task
    ObjectSpace.each_object( Task ) do |each|
      return each if each.name == "default"
    end
    fail "default タスクが定義されていない"
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
