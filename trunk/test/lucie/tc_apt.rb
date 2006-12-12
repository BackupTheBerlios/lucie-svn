#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift './lib'


require 'flexmock'
require 'lucie/apt'
require 'test/unit'


class TC_Apt < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_clean
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock_no_root
      block.call shell
      shell
    end

    apt = Apt.new( 'clean' )

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_symbol
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock_no_root
      block.call shell
      shell
    end

    apt = Apt.new( :clean )

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_with_block_with_root
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock
      block.call shell
      shell
    end

    apt = Apt.new( 'clean' ) do | option |
      option.root = '/ROOT'
    end

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_symbol_with_block_with_root
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock
      block.call shell
      shell
    end

    apt = Apt.new( :clean ) do | option |
      option.root = '/ROOT'
    end

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_with_block_with_no_root
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock_no_root
      block.call shell
      shell
    end

    apt = Apt.new( 'clean' ) do | option |
      # do nothing.
    end

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_abbreviation
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock
      block.call shell
      shell
    end

    apt = apt( :clean ) do | option |
      option.root = '/ROOT'
    end

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def test_clean_abbreviation_no_block
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = shell_mock_no_root
      block.call shell
      shell
    end

    apt = apt( :clean )

    assert_equal 'CHILD_STATUS_MOCK', apt.child_status
  end


  def shell_mock
    shell = flexmock( 'SHELL' )
    shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'clean' )
    shell.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS_MOCK' )
    return shell
  end


  def shell_mock_no_root
    shell = flexmock( 'SHELL' )
    shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'apt-get', 'clean' )
    shell.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS_MOCK' )
    return shell
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
