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
  include FlexMock::TestCase


  def test_new
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock
      block.call shell
      shell
    end

    debootstrap = Debootstrap.new do | option |
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'DHCP-CLIENT', 'INFO' ]
      option.suite = 'WOODY'
      option.target = '/TMP'
      option.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
    end

    assert_equal 'CHILD_STATUS', debootstrap.child_status
  end


  def test_abbreviation
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock
      block.call shell
      shell
    end

    debootstrap = debootstrap do | option |
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'DHCP-CLIENT', 'INFO' ]
      option.suite = 'WOODY'
      option.target = '/TMP'
      option.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
    end

    assert_equal 'CHILD_STATUS', debootstrap.child_status
  end


  def shell_mock
    return flexmock( 'SHELL' ) do | mock |
      # tochild thread
      mock.should_receive( :puts ).at_least.once

      # fromchild thread
      flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE0' ).once.ordered
      flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE1' ).once.ordered
      flexstub( STDOUT, 'STDOUT' ).should_receive( :puts ).with( 'STDOUT_LINE2' ).once.ordered
      mock.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDOUT_LINE0'
        block.call 'STDOUT_LINE1'
        block.call 'STDOUT_LINE2'
      end

      # childerr thread
      flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE0' ).once.ordered
      flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE1' ).once.ordered
      flexstub( STDERR, 'STDERR' ).should_receive( :puts ).with( 'STDERR_LINE2' ).once.ordered
      mock.should_receive( :on_stderr ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDERR_LINE0'
        block.call 'STDERR_LINE1'
        block.call 'STDERR_LINE2'
      end

      mock.should_receive( :exec ).with( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }, *debootstrap_commandline ).once.ordered

      mock.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS' )
    end
  end


  def debootstrap_commandline
    return [ "/usr/sbin/debootstrap", "--exclude=DHCP-CLIENT,INFO", "WOODY", "/TMP", 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/' ]
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
