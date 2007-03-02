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
require 'install-packages/aptitude'
require 'test/unit'


class TC_Aptitude < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_install_without_recommends
    flexstub( Popen3::Shell, 'SHELL_CLASS_MOCK' ).should_receive( :new ).once.ordered.and_return do
      shell = flexmock( 'SHELL_MOCK' )
      shell.should_receive( :exec ).with( env, chroot_command + 'aptitude -R -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install'.split( ' ' ) + dummy_package ).once.ordered
      shell.should_receive( :exec ).with( env, chroot_command + [ 'apt-get', 'clean' ] ).once.ordered
      shell
    end

    assert_nothing_raised do
      InstallPackages::Aptitude.new( dummy_package ).install_without_recommends
    end
  end


  def test_install_with_recommends
    flexstub( Popen3::Shell, 'SHELL_CLASS_MOCK' ).should_receive( :new ).once.ordered.and_return do
      shell = flexmock( 'SHELL_MOCK' )
      shell.should_receive( :exec ).with( env, chroot_command + 'aptitude -r -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install'.split( ' ' ) + dummy_package ).once
      shell.should_receive( :exec ).with( env, chroot_command + [ 'apt-get', 'clean' ] ).once
      shell
    end

    assert_nothing_raised do
      InstallPackages::Aptitude.new( dummy_package ).install_with_recommends
    end
  end


  private


  def env
    return { 'LC_ALL' => 'C' }
  end


  def chroot_command
    return [ 'chroot', '/tmp/target' ]
  end


  def dummy_package
    return [ 'PACKAGE_A', 'PACKAGE_B', 'PACKAGE_C' ]
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
