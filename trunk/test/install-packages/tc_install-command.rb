#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'flexmock'
require 'install-packages/command/install'
require 'test/unit'


class TC_InstallCommand < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_respond_to_execute
    assert_respond_to InstallPackages::InstallCommand.new( 'APTGET_MOCK' ), :execute
  end


  def test_execute
    aptget_mock = flexmock( 'APTGET_MOCK' )
    aptget_mock.should_receive( :install ).with( false ).once

    assert_nothing_raised do
      InstallPackages::InstallCommand.new( aptget_mock ).execute
    end
  end


  def test_execute_dryrun
    aptget_mock = flexmock( 'APTGET_MOCK' )
    aptget_mock.should_receive( :install ).with( true ).once

    assert_nothing_raised do
      InstallPackages::InstallCommand.new( aptget_mock ).execute( true )
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
