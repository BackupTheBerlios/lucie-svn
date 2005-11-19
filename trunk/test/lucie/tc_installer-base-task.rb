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
  def test_installer_base_target_prerequisites
    Rake::InstallerBaseTask.new do |task|
      task.distribution = 'debian'
      task.distribution_version = 'woody'
    end
    assert_equal( ['/var/lib/lucie/installer_base/debian_woody.tgz'], 
                  Task[:installer_base].prerequisites,
                  ":installer_base �������� prerequisites ���������ʤ�" )
  end
  
  public
  def test_clobber_target_prerequisites
    Rake::InstallerBaseTask.new do |task|
      task.distribution = 'debian'
      task.distribution_version = 'woody'
    end
    assert_equal( ["clobber_installer_base"], 
                  Task[:clobber].prerequisites,
                  ":clobber �������� prerequisites ���������ʤ�" )
  end
  
  public
  def test_reinstaller_base_target_prerequisites
    Rake::InstallerBaseTask.new do |task|
      task.distribution = 'debian'
      task.distribution_version = 'woody'
    end
    assert_equal( ["clobber_installer_base", "installer_base"], 
                  Task[:reinstaller_base].prerequisites,
                  ":reinstaller_base �������� prerequisites ���������ʤ�" )
  end
  
  public
  def test_targets_defined
    Rake::InstallerBaseTask.new do |task|
      task.distribution = 'debian'
      task.distribution_version = 'woody'
    end
    assert_not_nil( Task[:installer_base], 
                    ':installer_base ���������������Ƥ��ʤ�' )
    assert_equal( "Build the debian version woody installer base tarball",
                  Task[:installer_base].comment, 
                  ":installer_base �������Υ����Ȥ����ꤵ��Ƥ��ʤ�" )
    
    assert_not_nil( Task[:reinstaller_base],
                    ':reinstaller_base ���������������Ƥ��ʤ�' )
    assert_equal( "Force a rebuild of the installer base tarball",
                  Task[:reinstaller_base].comment, 
                  ":reinstaller_base �������Υ����Ȥ����ꤵ��Ƥ��ʤ�" )
    
    assert_not_nil( Task[:clobber_installer_base],
                    ':clobber_installer_base ���������������Ƥ��ʤ�' )
    assert_equal( "Remove installer base filesystem",
                  Task[:clobber_installer_base].comment, 
                  ":clobber_installer_base �������Υ����Ȥ����ꤵ��Ƥ��ʤ�" )
    
    assert_not_nil( Task['/var/lib/lucie/installer_base'],
                    '/var/lib/lucie/installer_base �ǥ��쥯�ȥ꥿�������������Ƥ��ʤ�' )

    assert_not_nil( Task['/var/lib/lucie/installer_base/debian_woody.tgz'],
                    '/var/lib/lucie/installer_base/var/tmp/debian_woody.tgz �ե����륿�������������Ƥ��ʤ�' )
  end
  
  public
  def test_accessor
    installer_base_task = Rake::InstallerBaseTask.new do |task|
      task.dir = 'tmp'
      task.distribution = 'debian'
      task.distribution_version = 'sarge'
    end
    assert_equal( :installer_base, installer_base_task.name )
    assert_equal( 'tmp', installer_base_task.dir )
    assert_equal( 'debian', installer_base_task.distribution )
    assert_equal( 'sarge', installer_base_task.distribution_version )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
