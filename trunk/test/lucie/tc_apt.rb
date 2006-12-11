#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


$LOAD_PATH.unshift './lib'


require 'flexmock'
require 'lucie/apt'
require 'test/unit'


class TC_Apt < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_clean
    flexstub( Shell, 'SHELL' ).should_receive( :new ).with( Proc ).once.ordered.and_return do | block |
      shell_mock = flexmock( 'SHELL_MOCK' )
      shell_mock.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'clean' )
      block.call shell_mock
    end

    Apt.new( 'clean' ) do | option |
      option.root = '/ROOT'
    end
  end
end
