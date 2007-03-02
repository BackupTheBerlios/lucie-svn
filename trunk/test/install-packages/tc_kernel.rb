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
require 'install-packages/app'
require 'install-packages/aptget'
require 'install-packages/aptitude'
require 'install-packages/command/aptitude'
require 'install-packages/command/aptitude-r'
require 'install-packages/command/clean'
require 'install-packages/command/install'
require 'install-packages/command/remove'
require 'install-packages/kernel'
require 'test/unit'


class TC_Kernel < Test::Unit::TestCase
  include FlexMock::TestCase


  def setup
    InstallPackages::App.instance.invoker = nil
  end


  def test_install
    setup_stub InstallPackages::AptGet, InstallPackages::InstallCommand

    install( *dummy_package )
  end


  def test_remove
    setup_stub InstallPackages::AptGet, InstallPackages::RemoveCommand

    remove( *dummy_package )
  end


  def test_clean
    setup_stub InstallPackages::AptGet, InstallPackages::CleanCommand

    clean( *dummy_package )
  end


  def test_aptitude
    setup_stub InstallPackages::Aptitude, InstallPackages::AptitudeCommand

    aptitude( *dummy_package )
  end


  def test_aptitude_r
    setup_stub InstallPackages::Aptitude, InstallPackages::AptitudeRCommand

    aptitude_r( *dummy_package )
  end


  private


  def setup_stub receiverClass, commandClass
    flexstub( receiverClass ).should_receive( :new ).with( dummy_package ).once.and_return( 'RECEIVER_MOCK' )
    flexstub( commandClass ).should_receive( :new ).with( 'RECEIVER_MOCK' ).once.and_return do
      command_mock = flexmock( 'COMMAND_MOCK' )
      command_mock.should_receive( :respond_to? ).with( :execute ).once.ordered.and_return( true )
      command_mock
    end
  end


  def dummy_package
    return [ 'FOO', 'BAR', 'BAZ' ]
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
