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
  def test_total_task_size
    assert_equal 1, tasks.size, "default 以外にも Task が定義されている"
  end
  
  public
  def test_default_task_defined
    assert_equal "default", tasks[0].name, "タスクの名前が正しくない"
    assert_equal ["make_installer_template"], tasks[0].prerequisites, "Prerequisites が正しくない"
  end
  
  private
  def tasks
    _tasks = []
    ObjectSpace.each_object( Task ) do |each|
      _tasks << each
    end
    return _tasks
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
