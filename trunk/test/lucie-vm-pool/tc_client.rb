#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie-vm-pool/client'
require 'test/unit'

class TC_Client < Test::Unit::TestCase
  public
  def setup
    $socket_mock = Mock.new( '#<Socket (Mock)>' )
  end
  
  public
  def teardown
    $socket_mock.__verify
  end
  
  public
  def test_get_num_nodes_success
    $socket_mock.__next( :print ) do |command|
      assert_equal( "GET #nodes upperbound\r\n", command, '�R�}���h���������Ȃ�' )
    end
    $socket_mock.__next( :gets ) do "0 64\r\n" end
    assert_equal( "64", LucieVmPool::Client.get( $socket_mock, '#nodes upperbound' ), 
                  '�m�[�h���̏���l���������Ȃ�' )
  end
  
  public
  def test_get_hdd_size_upperbound_success
    $socket_mock.__next( :print ) do |command|
      assert_equal( "GET hdd size upperbound\r\n", command, '�R�}���h���������Ȃ�' )
    end
    $socket_mock.__next( :gets ) do "0 4\r\n" end
    assert_equal( "4", LucieVmPool::Client.get( $socket_mock, 'hdd size upperbound' ), 
                  'HDD �T�C�Y�̏���l���������Ȃ�' )
  end
  
  public
  def test_get_memory_size_upperbound_success
    $socket_mock.__next( :print ) do |command|
      assert_equal( "GET memory size upperbound\r\n", command, '�R�}���h���������Ȃ�' )
    end
    $socket_mock.__next( :gets ) do "0 64\r\n" end
    assert_equal( "64", LucieVmPool::Client.get( $socket_mock, 'memory size upperbound' ), 
                  '�������T�C�Y�̏���l���������Ȃ�' )
  end
  
  public
  def test_get_vm_success
    $socket_mock.__next( :print ) do |command|
      assert_equal( "GET vm\r\n", command, '�R�}���h���������Ȃ�' )
    end
    $socket_mock.__next( :gets ) do "0 xen, colinux, vmware\r\n" end
    assert_equal( "xen, colinux, vmware", LucieVmPool::Client.get( $socket_mock, 'vm' ), 
                  '���p�\�� VM �̎�ނ��������Ȃ�' )    
  end
  
  public
  def test_get_distro_success
    $socket_mock.__next( :print ) do |command|
      assert_equal( "GET distro\r\n", command, '�R�}���h���������Ȃ�' )
    end
    $socket_mock.__next( :gets ) do "0 Debian (woody), Debian (sarge), redhat7,3\r\n" end
    assert_equal( "Debian (woody), Debian (sarge), redhat7,3", LucieVmPool::Client.get( $socket_mock, 'distro' ),
                  '���p�\�ȃf�B�X�g���r���[�V�����̎�ނ��������Ȃ�' )  
  end
  
  public
  def test_syntax_error
    assert_raises( LucieVmPool::Error::SyntaxError, "SyntaxError �� raise ����Ȃ�����" ) do 
      LucieVmPool::Client.parse_response( '20 syntaxerror' )
    end
    
    assert_raises( LucieVmPool::Error::SyntaxError, "SyntaxError �� raise ����Ȃ�����" ) do 
      LucieVmPool::Client.parse_response( '25 syntaxerror' )
    end
    
    assert_raises( LucieVmPool::Error::SyntaxError, "SyntaxError �� raise ����Ȃ�����" ) do 
      LucieVmPool::Client.parse_response( '29 syntaxerror' )
    end
  end
  
  public
  def test_invalid_parameters_exception
    assert_raises( LucieVmPool::Exception::InvalidParametersException, 
                   "InvalidParametersException �� raise ����Ȃ�����" ) do
      LucieVmPool::Client.parse_response( '10 invalid parameters exeption' )
    end
    
    assert_raises( LucieVmPool::Exception::InvalidParametersException,
                   "InvalidParametersException �� raise ����Ȃ�����" ) do
      LucieVmPool::Client.parse_response( '15 invalid parameters exeption' )
    end
    
    assert_raises( LucieVmPool::Exception::InvalidParametersException,
                   "InvalidParametersException �� raise ����Ȃ�����" ) do
      LucieVmPool::Client.parse_response( '19 invalid parameters exeption' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
