$LOAD_PATH.unshift "../../lib"


require 'flexmock'
require 'lucie/popen3'
require 'test/unit'

class TC_Popen3 < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_kernel_popen3_no_block
    prepare_popen3_no_block_mock

    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    tochild, fromchild, childerr = popen3( 'COMMAND', 'ARG1', 'ARG2' )
    assert_equal 'TOCHILD', tochild.mock_name
    assert_equal 'FROMCHILD', fromchild.mock_name
    assert_equal 'CHILDERR', childerr.mock_name
  end


  def test_wait
    prepare_popen3_no_block_mock

    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered
    flexstub( Process, 'PROCESS' ).should_receive( :wait ).with( dummy_pid ).once

    process = Popen3.new( 'COMMAND', 'ARG1', 'ARG2' )
    process.popen3
    process.wait
  end


  def test_popen3_no_block
    prepare_popen3_no_block_mock

    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    tochild, fromchild, childerr = Popen3.new( 'COMMAND', 'ARG1', 'ARG2' ).popen3
    assert_equal 'TOCHILD', tochild.mock_name
    assert_equal 'FROMCHILD', fromchild.mock_name
    assert_equal 'CHILDERR', childerr.mock_name
  end


  def test_kernel_popen3_with_block
    prepare_popen3_with_block_mock

    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    popen3( 'COMMAND', 'ARG1', 'ARG2' ) do | tochild, fromchild, childerr |
      assert_equal 'TOCHILD', tochild.mock_name
      assert_equal 'FROMCHILD', fromchild.mock_name
      assert_equal 'CHILDERR', childerr.mock_name
    end
  end


  def test_popen3_with_block
    prepare_popen3_with_block_mock

    flexstub( Kernel, 'KERNEL' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    popen3 = Popen3.new( 'COMMAND', 'ARG1', 'ARG2' )
    popen3.popen3 do | tochild, fromchild, childerr |
      assert_equal 'TOCHILD', tochild.mock_name
      assert_equal 'FROMCHILD', fromchild.mock_name
      assert_equal 'CHILDERR', childerr.mock_name
    end
  end


  def prepare_popen3_with_block_mock
    ncall_pipe = 0
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return do
      ncall_pipe += 1
      child_stdin = flexmock( 'CHILD_STDIN' )
      tochild = flexmock( 'TOCHILD' )
      fromchild = flexmock( 'FROMCHILD' )
      child_stdout = flexmock( 'CHILD_STDOUT' )
      childerr = flexmock( 'CHILDERR' )
      child_stderr = flexmock( 'CHILD_STDERR' )

      case ncall_pipe
      when 1
        # child process ########################################################
        tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        tochild.should_receive( :close ).with_no_args.once.ordered

        child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdin.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdin.should_receive( :close ).with_no_args.once.ordered

        tochild.should_receive( :sync= ).with( true ).once.ordered

        tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        tochild.should_receive( :close ).with_no_args.once.ordered

        [ child_stdin, tochild ]
      when 2
        # child process ########################################################
        fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        fromchild.should_receive( :close ).with_no_args.once.ordered

        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        fromchild.should_receive( :close ).with_no_args.once.ordered

        [ fromchild, child_stdout ]
      when 3
        # child process ########################################################
        childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        childerr.should_receive( :close ).with_no_args.once.ordered

        child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stderr.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stderr.should_receive( :close ).with_no_args.once.ordered

        childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        childerr.should_receive( :close ).with_no_args.once.ordered

        [ childerr, child_stderr ]
      end
    end
    flexstub( Kernel, 'KERNEL' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDIN' end ).once
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDOUT' end ).once
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDERR' end ).once
  end


  def prepare_popen3_no_block_mock
    ncall_pipe = 0
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return do
      ncall_pipe += 1
      child_stdin = flexmock( 'CHILD_STDIN' )
      tochild = flexmock( 'TOCHILD' )
      fromchild = flexmock( 'FROMCHILD' )
      child_stdout = flexmock( 'CHILD_STDOUT' )
      childerr = flexmock( 'CHILDERR' )
      child_stderr = flexmock( 'CHILD_STDERR' )

      case ncall_pipe
      when 1
        # child process ########################################################
        tochild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        tochild.should_receive( :close ).with_no_args.once.ordered

        child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdin.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stdin.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdin.should_receive( :close ).with_no_args.once.ordered

        tochild.should_receive( :sync= ).with( true ).once.ordered

        [ child_stdin, tochild ]
      when 2
        # child process ########################################################
        fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        fromchild.should_receive( :close ).with_no_args.once.ordered

        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        [ fromchild, child_stdout ]
      when 3
        # child process ########################################################
        childerr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        childerr.should_receive( :close ).with_no_args.once.ordered

        child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stderr.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stderr.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stderr.should_receive( :close ).with_no_args.once.ordered

        [ childerr, child_stderr ]
      end
    end
    flexstub( Kernel, 'KERNEL' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDIN' end ).once
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDOUT' end ).once
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'CHILD_STDERR' end ).once
  end


  def dummy_pid
    return 'DUMMY_PID'
  end
end
