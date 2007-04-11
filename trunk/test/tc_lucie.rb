#!/usr/bin/env ruby
#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift( '../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'flexmock'
require 'lucie'
require 'test/unit'


class TC_Lucie < Test::Unit::TestCase
  include FlexMock::TestCase


  def setup
    io_mock = flexmock( 'IO' )
    io_mock.should_receive( :puts ).with( String ).once.and_return( 'DUMMY_RETURN_VALUE' )
    Lucie.load_io io_mock
  end


  def teardown
    Lucie.reset
  end


  def test_logging_level
    Lucie.logging_level = :warn

    assert_equal 'DUMMY_RETURN_VALUE', Lucie.fatal( 'TEST' )
    assert_equal 'DUMMY_RETURN_VALUE', Lucie.error( 'TEST' )
    assert_equal 'DUMMY_RETURN_VALUE', Lucie.warn( 'TEST' )
    assert_nil Lucie.info( 'TEST' )
    assert_nil Lucie.debug( 'TEST' )
  end


  def test_fatal
    assert_nothing_raised do
      Lucie.fatal 'TEST'
    end
  end


  def test_error
    assert_nothing_raised do
      Lucie.error 'TEST'
    end
  end


  def test_warn
    assert_nothing_raised do
      Lucie.warn 'TEST'
    end
  end


  def test_info
    assert_nothing_raised do
      Lucie.info 'TEST'
    end
  end


  def test_debug
    assert_nothing_raised do
      Lucie.debug 'TEST'
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
