#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'rake'
require 'test/unit'

class TC_Task_Installer_Template < Test::Unit::TestCase
  public
  def setup
    Task::clear
  end
  
  # テンプレートディレクトリが存在しない場合の installer_template_message の prerequisites を確認
  public
  def test_installer_template_without_template_directory   
    if FileTest.directory? dummy_template_lucie_directory_path
      Dir.rmdir dummy_template_lucie_directory_path      
    end      
    $template_lucie_directory = dummy_template_lucie_directory_path
    load 'lucie/rake/installer_template.rb'
    
    assert_equal( 2, task( 'installer_template' ).prerequisites.size, 'installer_template タスクの Prerequisites の数が正しくない' )
    assert_equal( 'installer_template_message', task( 'installer_template' ).prerequisites[0], 'installer_template タスクの Prerequisites[0] が正しくない' )
    assert_equal( 'create_base', task( 'installer_template' ).prerequisites[1], 'installer_template タスクの Prerequisites[1] が正しくない' )
  end
  
  # テンプレートディレクトリが存在する場合の installer_template_message の prerequisites を確認
  public
  def test_installer_template_with_template_directory
    begin
      unless FileTest.directory? dummy_template_lucie_directory_path
        Dir.mkdir dummy_template_lucie_directory_path        
      end  
      $template_lucie_directory = dummy_template_lucie_directory_path  
      load 'lucie/rake/installer_template.rb'

      assert_equal( 3, task( 'installer_template' ).prerequisites.size, 'installer_template タスクの Prerequisites の数が正しくない' )     
      assert_equal( 'installer_template_message', task( 'installer_template' ).prerequisites[0], 'installer_template タスクの Prerequisites[0] が正しくない' )
      assert_equal( 'kill_old_template_lucie_directory', task( 'installer_template' ).prerequisites[1], 'installer_template タスクの Prerequisites[1] が正しくない' )
      assert_equal( 'create_base', task( 'installer_template' ).prerequisites[2], 'installer_template タスクの Prerequisites[2] が正しくない' )
    ensure
      Dir.rmdir dummy_template_lucie_directory_path
    end
  end
  
  private
  def dummy_template_lucie_directory_path
    return Dir.pwd + '/' + 'TEMPLATE_LUCIE_DIRECTORY_PATH'
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
