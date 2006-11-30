$LOAD_PATH.unshift "../../lib"


require 'flexmock'
require 'lucie/popen3'
require 'test/unit'


class TC_Popen3 < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_popen3_no_block
    ncall_pipe = 0
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return do
      ncall_pipe += 1
      child_stdin = flexmock( 'child_stdin' )
      tochild = flexmock( 'tochild' )
      fromchild = flexmock( 'fromchild' )
      child_stdout = flexmock( 'child_stdout' )
      childerr = flexmock( 'childerr' )
      child_stderr = flexmock( 'child_stderr' )

      case ncall_pipe
      when 1
        # child process (within fork block) ####################################
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
        # child process (within fork block) ####################################
        fromchild.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        fromchild.should_receive( :close ).with_no_args.once.ordered

        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        # Parent process #######################################################
        child_stdout.should_receive( :closed? ).with_no_args.once.ordered.and_return( false )
        child_stdout.should_receive( :close ).with_no_args.once.ordered

        [ fromchild, child_stdout ]
      when 3
        # child process (within fork block) ####################################
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

    # Mocking child process behaviour ##########################################
    flexstub( Kernel, 'Kernel' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stdin' end ).once
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stdout' end ).once
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stderr' end ).once

    flexstub( Kernel, 'Kernel' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    # Mocking parent process behaviour #########################################
    flexstub( Process, 'Process' ).should_receive( :waitpid ).with( dummy_pid ).once

    tochild, fromchild, childerr = Popen3.new( 'COMMAND', 'ARG1', 'ARG2' ).popen3
    assert_equal 'tochild', tochild.mock_name
    assert_equal 'fromchild', fromchild.mock_name
    assert_equal 'childerr', childerr.mock_name
  end


  def test_popen3_with_block
    ncall_pipe = 0
    flexstub( IO, 'IO' ).should_receive( :pipe ).times( 3 ).with_no_args.and_return do
      ncall_pipe += 1
      child_stdin = flexmock( 'child_stdin' )
      tochild = flexmock( 'tochild' )
      fromchild = flexmock( 'fromchild' )
      child_stdout = flexmock( 'child_stdout' )
      childerr = flexmock( 'childerr' )
      child_stderr = flexmock( 'child_stderr' )

      case ncall_pipe
      when 1
        # child process (within fork block) ####################################
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
        # child process (within fork block) ####################################
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
        # child process (within fork block) ####################################
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

    # Mocking child process behaviour ##########################################
    flexstub( Kernel, 'Kernel' ).should_receive( :fork ).with( Proc ).once.ordered.and_return do | block |
      block.call
      dummy_pid
    end

    flexstub( STDIN, 'STDIN' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stdin' end ).once
    flexstub( STDOUT, 'STDOUT' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stdout' end ).once
    flexstub( STDERR, 'STDERR' ).should_receive( :reopen ).
      with( on do | mock | mock.mock_name == 'child_stderr' end ).once

    flexstub( Kernel, 'Kernel' ).should_receive( :exec ).with( 'COMMAND', 'ARG1', 'ARG2' ).once.ordered

    # Mocking parent process behaviour #########################################
    flexstub( Process, 'Process' ).should_receive( :waitpid ).with( dummy_pid ).once

    popen3 = Popen3.new( 'COMMAND', 'ARG1', 'ARG2' )
    popen3.popen3 do | tochild, fromchild, childerr | end
  end


  def dummy_pid
    return 100
  end
end
