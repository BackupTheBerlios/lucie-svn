#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift 'trunk/lib'

require 'test/unit'
require 'lucie/setup-harddisk'

class TC_SetupHarddisk < Test::Unit::TestCase
  def test_truth
    assert true
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: