#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift './lib'


require 'flexmock'
require 'lucie/debootstrap'
require 'test/unit'


class TC_Debootstrap < Test::Unit::TestCase
  def setup
    @debootstrap = Debootstrap.new
    @debootstrap.option do | option |
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'dhcp-client', 'info' ]
      option.suite = 'woody'
      option.target = '/tmp'
      option.mirror = 'http://www.debian.or.jp/debian/'
    end
  end


  def test_new
    assert_equal( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }, @debootstrap.env )
    assert_equal [ 'dhcp-client', 'info' ], @debootstrap.exclude
    assert_equal 'woody', @debootstrap.suite
    assert_equal '/tmp', @debootstrap.target
    assert_equal 'http://www.debian.or.jp/debian/', @debootstrap.mirror
  end


  def test_new_with_block
    debootstrap = Debootstrap.new do | option |
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'dhcp-client', 'info' ]
      option.suite = 'woody'
      option.target = '/tmp'
      option.mirror = 'http://www.debian.or.jp/debian/'
    end

    assert_equal( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }, debootstrap.env )
    assert_equal [ 'dhcp-client', 'info' ], debootstrap.exclude
    assert_equal 'woody', debootstrap.suite
    assert_equal '/tmp', debootstrap.target
    assert_equal 'http://www.debian.or.jp/debian/', debootstrap.mirror
  end


  def test_commandline
    assert_equal [ "/usr/sbin/debootstrap", "--exclude=dhcp-client,info", "woody", "/tmp", "http://www.debian.or.jp/debian/" ],  @debootstrap.commandline
  end
end


class TC_DebootstrapRunner < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_run
    flexstub( Shell, 'SHELL' ).should_receive( :new ).with_no_args.once.ordered.and_return do
      flexmock( 'SHELL' ) do | mock |
        mock.should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
          block.call shell_exec
        end
      end
    end
    flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE0' ).once.ordered
    flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE1' ).once.ordered
    flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE2' ).once.ordered

    flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE0' ).once.ordered
    flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE1' ).once.ordered
    flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE2' ).once.ordered

    runner = DebootstrapRunner.new
    runner.load_option debootstrap_mock
    runner.run
  end


  def debootstrap_mock
    return flexmock( 'DEBOOTSTRAP' ) do | mock |
      mock.should_receive( :env ).once.ordered.and_return( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' } )
      mock.should_receive( :commandline ).once.ordered.and_return( debootstrap_commandline )
    end
  end


  def debootstrap_commandline
    return [ "/usr/sbin/debootstrap", "--exclude=dhcp-client,info", "woody", "/tmp", "http://www.debian.or.jp/debian/" ]
  end


  def shell_exec
    return flexmock( 'SHELL_EXEC' ) do | mock |
      mock.should_receive( :puts ).at_least.once
      mock.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDOUT_LINE0'
        block.call 'STDOUT_LINE1'
        block.call 'STDOUT_LINE2'
      end
      mock.should_receive( :on_stderr ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDERR_LINE0'
        block.call 'STDERR_LINE1'
        block.call 'STDERR_LINE2'
      end
      mock.should_receive( :exec ).with( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }, *debootstrap_commandline ).once.ordered
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
