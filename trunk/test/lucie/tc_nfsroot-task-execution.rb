#
# $Id: tc_installer-base-task.rb 399 2005-03-15 10:00:02Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 399 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rake'
require 'lucie/nfsroot-task'
require 'test/unit'

class TC_NfsrootTaskExecution < Test::Unit::TestCase
  public
  def test_execute_installer_base_task
    Rake::NfsrootTask.new do |nfsroot|
      nfsroot.installer_base='tmp/installer_base/var/tmp/debian_woody.tgz'
      nfsroot.dir='tmp/nfsroot'
    end
    Task[:nfsroot].invoke
    # assert( File.exists?( 'tmp/var/tmp/debian_woody.tgz' ) )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: