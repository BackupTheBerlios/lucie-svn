#
# $Id: tc_installer-base-task.rb 399 2005-03-15 10:00:02Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 399 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rake'
require 'lucie/installer-base-task'
require 'test/unit'

class TC_InstallerBaseTaskExecution < Test::Unit::TestCase
  public
  def test_execute_installer_base_task
    Rake::InstallerBaseTask.new do |installer_base|
      installer_base.dir = "tmp/installer_base"
      installer_base.distribution = "debian"
      installer_base.distribution_version = "woody"
    end
    Task[:installer_base].invoke
    assert( File.exists?( 'tmp/var/tmp/debian_woody.tgz' ) )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: