#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/package-server'
require 'test/unit'

class TC_PackageServerDefinition < Test::Unit::TestCase
  public
  def teardown
    Lucie::Config::PackageServer.clear
  end
  
  public
  def test_accessor
    pkgserver = Lucie::Config::PackageServer.new do |pkgserver|
      pkgserver.name         = 'debian_mirror'
      pkgserver.alias       = 'Local Debian Repository Mirror'
      pkgserver.address      = '192.168.1.100'
      pkgserver.protocol     = 'http'
      pkgserver.distribution = 'debian'
    end
    
    assert_equal( 'debian_mirror', pkgserver.name )
    assert_equal( 'Local Debian Repository Mirror', pkgserver.alias )
    assert_equal( '192.168.1.100', pkgserver.address )
    assert_equal( 'http', pkgserver.protocol )
    assert_equal( 'debian', pkgserver.distribution )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: