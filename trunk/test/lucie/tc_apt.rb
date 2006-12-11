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


class TC_AptOption < Test::Unit::TestCase
  def test_new
    apt_option = AptOption.new do | option |
      option.root = '/ROOT'
    end
    assert_equal '/ROOT', apt_option.root
  end
end


class TC_Apt < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_new
    mock = flexstub( AptOption, 'APT_OPTION' )
    apt = Apt.new( mock )
  end


  def test_clean
    flexstub( Shell, 'SHELL' ).should_receive( :new ).with( Proc ).once.ordered.and_return do | block |
      shell_mock = flexmock( 'SHELL_MOCK' )
      shell_mock.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'clean' )
      block.call shell_mock
    end
    apt_option_mock = flexmock( 'APT_OPTION' )
    apt_option_mock.should_receive( :root ).with_no_args.once.ordered.and_return( '/ROOT' )

    apt = Apt.new( apt_option_mock )
    apt.clean
  end
end
