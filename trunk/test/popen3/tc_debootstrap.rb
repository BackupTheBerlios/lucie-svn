#!/usr/bin/env ruby
#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'flexmock'
require 'popen3/debootstrap'
require 'test/unit'


class TC_Debootstrap < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_version
    shell = flexmock( 'SHELL_MOCK' )
    shell.should_receive( :start ).with( Proc ).once.ordered.and_return do | block |
      shell.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | stdout_block |
        stdout_block.call 'ii  debootstrap    0.2.45-0.2     Bootstrap a basic Debian system'
      end
      shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'dpkg', '-l' ).once.ordered

      block.call shell
    end

    flexstub( Popen3::Shell, 'SHELL_CLASS_MOCK' ).should_receive( :new ).once.ordered.and_return( shell )

    assert_match( /[\d\.\-]+/, Popen3::Debootstrap.VERSION )
  end


  def test_new
    setup_shell_mock

    logger_mock = flexmock( 'LOGGER_MOCK' )
    logger_mock.should_receive( :debug ).with( /\ASTDOUT_LINE\d\Z/ ).times( 3 )
    logger_mock.should_receive( :error ).with( /\ASTDERR_LINE\d\Z/ ).times( 3 )

    debootstrap = Popen3::Debootstrap.new do | option |
      option.logger = logger_mock
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'DHCP-CLIENT', 'INFO' ]
      option.suite = 'WOODY'
      option.target = '/TMP'
      option.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      option.include = [ 'INCLUDE' ]
    end

    assert_equal 'CHILD_STATUS', debootstrap.child_status
  end


  def test_abbreviation
    setup_shell_mock

    debootstrap = debootstrap do | option |
      option.env = { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }
      option.exclude = [ 'DHCP-CLIENT', 'INFO' ]
      option.suite = 'WOODY'
      option.target = '/TMP'
      option.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      option.include = [ 'INCLUDE' ]
    end

    assert_equal 'CHILD_STATUS', debootstrap.child_status
  end


  def setup_shell_mock
    shell = flexmock( 'SHELL_MOCK' )
    shell.should_receive( :start ).with( Proc ).once.ordered.and_return do | block |
      # tochild thread
      shell.should_receive( :puts ).at_least.once

      # fromchild thread
      shell.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDOUT_LINE0'
        block.call 'STDOUT_LINE1'
        block.call 'STDOUT_LINE2'
      end

      # childerr thread
      shell.should_receive( :on_stderr ).with( Proc ).once.ordered.and_return do | block |
        block.call 'STDERR_LINE0'
        block.call 'STDERR_LINE1'
        block.call 'STDERR_LINE2'
      end

      shell.should_receive( :on_failure ).with( Proc ).once.ordered.and_return do | block |
        assert_raises( RuntimeError ) do
          block.call
        end
      end

      shell.should_receive( :exec ).with( { 'TEST_ENV_NAME' => 'TEST_ENV_VALUE' }, *debootstrap_commandline ).once.ordered

      shell.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS' )
      block.call shell
      shell
    end
    flexstub( Popen3::Shell, 'SHELL_CLASS' ).should_receive( :new ).once.ordered.and_return( shell )
  end

  def debootstrap_commandline
    return [ "/usr/sbin/debootstrap", "--exclude=DHCP-CLIENT,INFO", "--include=INCLUDE", "WOODY", "/TMP", 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/' ]
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
