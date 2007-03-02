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
require 'test/unit'


class TC_App < Test::Unit::TestCase
  include FlexMock::TestCase


  def setup
    InstallPackages::App.instance.invoker = nil
  end


  def test_exit_version_option
    option = flexmock( 'OPTION_MOCK' )
    option.should_receive( :version ).once.ordered.and_return( true )

    assert_raises( SystemExit ) do
      InstallPackages::App.instance.main option
    end
  end


  def test_exit_help_option
    option = flexmock( 'OPTION_MOCK' )
    option.should_receive( :version ).once.ordered.and_return( nil )
    option.should_receive( :help ).once.ordered.and_return( true )

    assert_raises( SystemExit ) do
      InstallPackages::App.instance.main option
    end
  end


  def test_install_command
    option = option_mock( 'install' )
    setup_invoker_stub InstallPackages::InstallCommand, option

    app = InstallPackages::App.instance
    assert_nothing_raised do
      app.main option
    end
  end


  def test_remove_comand
    option = option_mock( 'remove' )
    setup_invoker_stub InstallPackages::RemoveCommand, option

    app = InstallPackages::App.instance
    assert_nothing_raised do
      app.main option
    end
  end


  def test_clean_comand
    option = option_mock( 'clean' )
    setup_invoker_stub InstallPackages::CleanCommand, option

    app = InstallPackages::App.instance
    assert_nothing_raised do
      app.main option
    end
  end


  def test_aptitude_command
    option = option_mock( 'aptitude' )
    setup_invoker_stub InstallPackages::AptitudeCommand, option

    app = InstallPackages::App.instance
    assert_nothing_raised do
      app.main option
    end
  end


  def test_aptitude_r_command
    option = option_mock( 'aptitude-r' )
    setup_invoker_stub InstallPackages::AptitudeRCommand, option

    app = InstallPackages::App.instance
    assert_nothing_raised do
      app.main option
    end
  end


  private


  def setup_invoker_stub commandClass, option
    flexstub( InstallPackages::Invoker, 'INVOKER_CLASS_MOCK' ).should_receive( :new ).once.ordered.and_return do
      invoker = flexmock( 'INVOKER' )
      invoker.should_receive( :add_command ).with( commandClass ).once.ordered
      invoker.should_receive( :start ).with( option ).once.ordered
      invoker
    end
  end


  def option_mock command
    option = flexmock( 'OPTION_MOCK' )
    option.should_receive( :version ).once.ordered.and_return( nil )
    option.should_receive( :help ).once.ordered.and_return( nil )
    option.should_receive( :config_file ).twice.ordered.and_return( "fixtures/install-packages.#{ command }.conf" )
    return option
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
