$LOAD_PATH.unshift "../../lib"


require 'flexmock'
require 'lucie/shell'
require 'test/unit'


class TC_Shell < Test::Unit::TestCase
  include FlexMock::TestCase


  class ExternalCommandOnExit < ::Exception
  end


  def test_on_exit
    setup_popen3_mock nil

    assert_raises( ExternalCommandOnExit ) do
      shell.open do | shell |
        shell.on_exit do
          raise ExternalCommandOnExit
        end
        shell.exec *dummy_command
      end
    end
  end


  class ExternalCommandExecSuccess < ::Exception
  end


  def test_on_success
    setup_popen3_mock nil

    assert_raises( ExternalCommandExecSuccess ) do
      success_shell.open do | shell |
        shell.on_success do
          raise ExternalCommandExecSuccess
        end
        shell.exec *dummy_command
      end
    end
  end


  class ExternalCommandExecFailure < ::Exception
  end


  def test_on_failure
    setup_popen3_mock nil

    assert_raises( ExternalCommandExecFailure ) do
      failure_shell.open do | shell |
        shell.on_failure do
          raise ExternalCommandExecFailure
        end
        shell.exec *dummy_command
      end
    end
  end


  def test_puts
    tochild_mock = flexmock( 'CHILDERR' ) do | mock |
      mock.should_receive( :puts ).times( 2 ).ordered.and_return( 'PUTS1', 'PUTS2' )
    end
    setup_popen3_mock tochild_mock

    shell.open do | shell |
      shell.exec *dummy_command
      shell.puts 'PUTS1'
      shell.puts 'PUTS2'
    end
  end


  def test_on_stdout
    setup_popen3_mock nil
    ncall_on_stdout = 0

    shell.open do | shell |
      shell.on_stdout do | line |
        ncall_on_stdout += 1
        assert_equal "FROMCHILD_LINE#{ ncall_on_stdout }", line
      end
      shell.exec *dummy_command
    end
    assert_equal 2, ncall_on_stdout
  end


  def test_on_stderr
    setup_popen3_mock nil
    ncall_on_stderr = 0

    shell.open do | shell |
      shell.on_stderr do | line |
        ncall_on_stderr += 1
        assert_equal "CHILDERR_LINE#{ ncall_on_stderr }", line
      end
      shell.exec *dummy_command
    end
    assert_equal 2, ncall_on_stderr
  end


  ##############################################################################
  # Test helper methods
  ##############################################################################


  def success_shell
    return shell_mock( 0 )
  end
  alias :shell :success_shell


  def failure_shell
    return shell_mock( 1 )
  end


  def shell_mock exitstatus
    shell = Shell.new
    flexmock( 'PROCESS::STATUS' ) do | status_mock |
      status_mock.should_receive( :exitstatus ).at_most.once.and_return( exitstatus )
      shell.child_status = status_mock
    end
    return shell
  end


  def setup_popen3_mock tochild = tochild_mock, fromchild = fromchild_mock, childerr = childerr_mock
    flexstub( Popen3, 'POPEN3' ).should_receive( :new ).with( *dummy_command ).once.and_return do
      flexmock( 'POPEN3' ) do | mock |
        mock.should_receive( :popen3 ).with( Proc ).once.ordered.and_return do | block |
          block.call tochild, fromchild, childerr
        end
        mock.should_receive( :wait ).with_no_args.once.ordered
      end
    end
  end


  def fromchild_mock
    return flexmock( 'FROMCHILD' ) do | mock |
      mock.should_receive( :gets ).times( 3 ).ordered.and_return( 'FROMCHILD_LINE1', 'FROMCHILD_LINE2', nil )
    end
  end


  def childerr_mock
    return flexmock( 'CHILDERR' ) do | mock |
      mock.should_receive( :gets ).times( 3 ).ordered.and_return( 'CHILDERR_LINE1', 'CHILDERR_LINE2', nil )
    end
  end


  def dummy_command
    return [ 'COMMAND', 'ARG1', 'ARG2' ]
  end
end
