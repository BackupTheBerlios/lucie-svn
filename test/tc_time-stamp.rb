#
# $Id: tc_time-stamp.rb 14 2005-01-19 06:32:24Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 1.6 $
# License::  GPL2

$LOAD_PATH.unshift '../lib'

require 'lucie/time-stamp'
require 'test/unit'

class TC_TimeStamp < Test::Unit::TestCase
  public
  def test_svn_date
    assert_match( /\A\d\d\d\d-\d\d-\d\d\Z/, Lucie::svn_date, "Lucie::svn_date returned wrong date format String." )
  end
end

# FIXME
# o 以下のブロックをテストで共通化する。
# o TestRunner の種類を Rake のターゲットなどで選択可能なようにする。
if __FILE__ == $0
  require 'test/unit/ui/tk/testrunner'
  require 'test/unit/testsuite'

  Test::Unit::UI::Tk::TestRunner.run( TC_TimeStamp )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
