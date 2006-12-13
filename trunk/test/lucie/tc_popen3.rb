$LOAD_PATH.unshift "./lib"


require 'flexmock'
require 'lucie/popen3'
require 'test/unit'


class TC_Popen3 < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_kernel_popen3_no_block
    prepare_popen3_no_block_mock

    tochild, fromchild, childerr = popen3( dummy_env, 'COMMAND', 'ARG1', 'ARG2' )
    assert_equal 'TOCHILD', tochild.mock_name
    assert_equal 'FROMCHILD', fromchild.mock_name
    assert_equal 'CHILDERR', childerr.mock_name
  end


  def test_wait
    prepare_popen3_no_block_mock
    flexstub( Process, 'PROCESS' ).should_receive( :wait ).with( dummy_pid ).once

    process = Popen3.new( dummy_env, 'COMMAND', 'ARG1', 'ARG2' )
    process.popen3
    process.wait
  end


  def test_popen3_no_block
    prepare_popen3_no_block_mock

    tochild, fromchild, childerr = Popen3.new( dummy_env, 'COMMAND', 'ARG1', 'ARG2' ).popen3
    assert_equal 'TOCHILD', tochild.mock_name
    assert_equal 'FROMCHILD', fromchild.mock_name
    assert_equal 'CHILDERR', childerr.mock_name
  end


  def test_kernel_popen3_with_block
    prepare_popen3_with_block_mock

    popen3( dummy_env, 'COMMAND', 'ARG1', 'ARG2' ) do | tochild, fromchild, childerr |
      assert_equal 'TOCHILD', tochild.mock_name
      assert_equal 'FROMCHILD', fromchild.mock_name
      assert_equal 'CHILDERR', childerr.mock_name
    end
  end


  def test_popen3_with_block
    prepare_popen3_with_block_mock

    popen3 = Popen3.new( dummy_env, 'COMMAND', 'ARG1', 'ARG2' )
    popen3.popen3 do | tochild, fromchild, childerr |
      assert_equal 'TOCHILD', tochild.mock_name
      assert_equal 'FROMCHILD', fromchild.mock_name
      assert_equal 'CHILDERR', childerr.mock_name
    end
  end


  def prepare_popen3_with_block_mock
    child_stdin = flexmock( 'CHILD_STDIN' )
    tochild = flexmock( 'TOCHILD' )
    fromchild = flexmock( 'FROMCHILD' )
    child_stdout = flexmock( 'CHILD_STDOUT' )
    childerr = flexmock( 'CHILDERR' )
    child_stderr = flexmock( 'CHILD_STDERR' )

    # init_pipe
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return( [ child_stdin, tochild ], [ fromchild, child_stdout ], [ childerr, child_stderr ] )

    # Kernel.fork
    flexstub( Kernel, 'KERNEL' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    # Child Process ############################################################

    # close_end_of @parent_pipe
    tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    tochild.should_receive( :close ).with_no_args.once.ordered
    fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    fromchild.should_receive( :close ).with_no_args.once.ordered
    childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    childerr.should_receive( :close ).with_no_args.once.ordered

    # STDIO repopen
    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDIN' end ).once.ordered
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDOUT' end ).once.ordered
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDERR' end ).once.ordered

    # close_end_of @child_pipe
    child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdin.should_receive( :close ).with_no_args.once.ordered
    child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdout.should_receive( :close ).with_no_args.once.ordered
    child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stderr.should_receive( :close ).with_no_args.once.ordered

    flexstub( ENV, 'ENV' ).should_receive( :[]= ).with( 'TEST_ENV_NAME', 'TEST_ENV_VALUE' ).once.ordered
    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    # Parent Process ###########################################################

    # close_end_of @child_pipe
    child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdin.should_receive( :close ).with_no_args.once.ordered
    child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdout.should_receive( :close ).with_no_args.once.ordered
    child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stderr.should_receive( :close ).with_no_args.once.ordered

    tochild.should_receive( :sync= ).with( true ).once.ordered

    # ensure close_end_of @parent_pipe
    tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    tochild.should_receive( :close ).with_no_args.once.ordered
    fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    fromchild.should_receive( :close ).with_no_args.once.ordered
    childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    childerr.should_receive( :close ).with_no_args.once.ordered
  end


  def prepare_popen3_no_block_mock
    child_stdin = flexmock( 'CHILD_STDIN' )
    tochild = flexmock( 'TOCHILD' )
    fromchild = flexmock( 'FROMCHILD' )
    child_stdout = flexmock( 'CHILD_STDOUT' )
    childerr = flexmock( 'CHILDERR' )
    child_stderr = flexmock( 'CHILD_STDERR' )

    # init_pipe
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return( [ child_stdin, tochild ], [ fromchild, child_stdout ], [ childerr, child_stderr ] )

    # Kernel.fork
    flexstub( Kernel, 'KERNEL' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    # Child Process ############################################################

    # close_end_of @parent_pipe
    tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    tochild.should_receive( :close ).with_no_args.once.ordered
    fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    fromchild.should_receive( :close ).with_no_args.once.ordered
    childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    childerr.should_receive( :close ).with_no_args.once.ordered

    # STDIO reopen
    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDIN' end ).once.ordered
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDOUT' end ).once.ordered
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).with( on do | mock | mock.mock_name == 'CHILD_STDERR' end ).once.ordered

    # close_end_of @child_pipe
    child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdin.should_receive( :close ).with_no_args.once.ordered
    child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdout.should_receive( :close ).with_no_args.once.ordered
    child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stderr.should_receive( :close ).with_no_args.once.ordered

    flexstub( ENV, 'ENV' ).should_receive( :[]= ).with( 'TEST_ENV_NAME', 'TEST_ENV_VALUE' ).once.ordered
    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    # Parent Process ############################################################

    # close_end_of @child_pipe
    child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdin.should_receive( :close ).with_no_args.once.ordered
    child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stdout.should_receive( :close ).with_no_args.once.ordered
    child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
    child_stderr.should_receive( :close ).with_no_args.once.ordered

    tochild.should_receive( :sync= ).with( true ).once.ordered
  end


  def dummy_env
    return { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
  end


  def dummy_pid
    return 'DUMMY_PID'
  end
end
