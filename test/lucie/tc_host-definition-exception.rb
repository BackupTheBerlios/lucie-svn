#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/host'
require 'test/unit'

class TC_HostDefinitionException < Test::Unit::TestCase
  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '��O�� raise ����Ȃ�����' ) do 
      Lucie::Config::Host.new do |host|
        host.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '��O�� raise ����Ȃ�����' ) do 
      Lucie::Config::Host.new do |host|
        host.name = '?'
      end
    end
  end
  
  public
  def test_nothing_raised
    assert_nothing_raised( '��O�� raise ���ꂽ' ) do 
      Lucie::Config::Host.new do |host|
        host.name = 'aiueo-kakikukeko_sasisuseso'
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: