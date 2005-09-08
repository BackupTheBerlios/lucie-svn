#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rubygems'
require_gem 'rake'
require 'lucie/nfsroot-task'
require 'test/unit'

class TC_NfsrootTask < Test::Unit::TestCase
  public
  def setup
    Task.clear    
  end
  
  public
  def teardown 
    Task.clear
  end
  
  public
  def test_targets_defined
    nfsroot_task = Rake::NfsrootTask.new do |task|
      task.installer_base = 'debian_woody.tgz'
    end   
    assert_not_nil( Task[:nfsroot], ':nfsroot ���������������Ƥ��ʤ�' )
    assert_equal( "Build the nfsroot filesytem using debian_woody.tgz",
                  Task[:nfsroot].comment, 
                  ":nfsroot �������Υ����Ȥ����ꤵ��Ƥ��ʤ�" )
    
    assert_not_nil( Task['/var/lib/lucie/nfsroot/'],
                    '/var/lib/lucie/nfsroot/ �ǥ��쥯�ȥ꥿�������������Ƥ��ʤ�' )
                    
    assert_not_nil( Task['/var/lib/lucie/nfsroot/lucie/timestamp'],
                    '/var/lib/lucie/nfsroot/lucie/timestamp �ե����륿�������������Ƥ��ʤ�' )
  end
  
  public
  def test_accessor
    nfsroot_task = Rake::NfsrootTask.new do |task|
      task.dir = 'tmp'
      task.installer_base = 'debian_woody'
    end    
    assert_equal( 'tmp', nfsroot_task.dir, 'tmp ���ȥ�ӥ塼�Ȥ��������ʤ�' )
    assert_equal( 'debian_woody', nfsroot_task.installer_base,
                  'debian_woody ���ȥ�ӥ塼�Ȥ��������ʤ�' )
  end  
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
