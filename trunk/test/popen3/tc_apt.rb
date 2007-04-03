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
require 'popen3/apt'
require 'test/unit'


class TC_Apt < Test::Unit::TestCase
  include FlexMock::TestCase


  def setup
    flexstub( Popen3::Shell, 'SHELL_CLASS_MOCK' ).should_receive( :new ).once.ordered.and_return do
      shell = flexmock( 'SHELL' )
      shell.should_receive( :open ).with( Proc ).once.ordered.and_return( shell )
      shell.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS_MOCK' )
      shell
    end
  end


  def test_apt_get_nooption
    result = Popen3::Apt.get( '-y dist-upgrade' )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_apt_get_withoption
    result = Popen3::Apt.get( '-y dist-upgrade', :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get check
  ##############################################################################


  def test_check_nooption
    result = Popen3::Apt.check
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_withoption
    result = Popen3::Apt.check( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_abbreviation_nooption
    result = aptget_check
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_check_abbreviation_withoption
    result = aptget_check( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get clean
  ##############################################################################


  def test_clean_nooption
    result = Popen3::Apt.clean
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_withoption
    result = Popen3::Apt.clean( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_abbreviation_nooption
    result = aptget_clean
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_clean_abbreviation_withoption
    result = aptget_clean( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  ##############################################################################
  # apt-get update
  ##############################################################################


  def test_update_nooption
    result = Popen3::Apt.update
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_withoption
    result = Popen3::Apt.update( :env => { 'ENV_NAME' => 'ENV_VALUE' } )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_abbreviation_nooption
    result = aptget_update
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end


  def test_update_abbreviation_withoption
    result = aptget_update( :root => '/ROOT', :env => { 'ENV_NAME' => 'ENV_VALUE' }, :logger => 'LOGGER_MOCK' )
    assert_equal 'CHILD_STATUS_MOCK', result.child_status
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
