#
# $Id: tc_setup.rb 21 2005-02-01 07:08:41Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 21 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/rake/installer_template'
require 'test/unit'

class TC_Task_Installer_Template < Test::Unit::TestCase
  public
  def test_installer_template_task_defined
    assert_equal( ["installer_template_message"], task('installer_template').prerequisites,
     "installer_template タスクの Prerequisites が正しくない" )
  end
  
  private
  def task( taskNameString )
    ObjectSpace.each_object( Task ) do |each|
      return each if each.name == taskNameString
    end
    fail "#{taskNameString} タスクが定義されていない"
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
