#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/time-stamp'
require 'test/unit'

class TC_TimeStamp < Test::Unit::TestCase
  public
  def test_svn_date
    assert_match( /\A\d\d\d\d-\d\d-\d\d\Z/, Lucie::svn_date, "Lucie::svn_date returned wrong date format String." )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
