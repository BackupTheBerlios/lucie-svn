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
require 'lucie/apt'
require 'test/unit'


class TC_Apt < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_apt_get_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', '-y dist-upgrade' )
      block.call shell
      shell
    end

    result = Apt.get( '-y dist-upgrade' )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_apt_get_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', '-y dist-upgrade' )
      block.call shell
      shell
    end

    result = Apt.get( '-y dist-upgrade', :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get check
  ##############################################################################


  def test_check_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'check' )
      block.call shell
      shell
    end

    result = Apt.check
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'apt-get', 'check' )
      block.call shell
      shell
    end

    result = Apt.check( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_abbreviation_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'check' )
      block.call shell
      shell
    end

    result = aptget_check
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_abbreviation_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'check' )
      block.call shell
      shell
    end

    result = aptget_check( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get clean
  ##############################################################################


  def test_clean_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'clean' )
      block.call shell
      shell
    end

    result = Apt.clean
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'apt-get', 'clean' )
      block.call shell
      shell
    end

    result = Apt.clean( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_abbreviation_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'clean' )
      block.call shell
      shell
    end

    result = aptget_clean
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_abbreviation_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'clean' )
      block.call shell
      shell
    end

    result = aptget_clean( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get update
  ##############################################################################


  def test_update_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'update' )
      block.call shell
      shell
    end

    result = Apt.update
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'apt-get', 'update' )
      block.call shell
      shell
    end

    result = Apt.update( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_abbreviation_nooption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'LC_ALL' => 'C' }, 'apt-get', 'update' )
      block.call shell
      shell
    end

    result = aptget_update
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_abbreviation_withoption
    flexstub( Shell, 'SHELL_CLASS_MOCK' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock( { 'ENV_NAME' => 'ENV_VALUE', 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'update' )
      block.call shell
      shell
    end

    result = aptget_update( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  private


  def shell_mock *commandline
    lucie = flexstub( Lucie, 'LUCIE_CLASS_MOCK' )
    lucie.should_receive( :debug ).with( 'DUMMY_STDOUT' ).once.ordered
    lucie.should_receive( :error ).with( 'DUMMY_STDERR' ).once.ordered

    shell = flexmock( 'SHELL' )
    shell.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | block |
      block.call 'DUMMY_STDOUT'
    end
    shell.should_receive( :on_stderr ).with( Proc ).once.ordered.and_return do | block |
      block.call 'DUMMY_STDERR'
    end
    shell.should_receive( :exec ).with( *commandline ).once.ordered
    shell.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS_MOCK' )
    return shell
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
