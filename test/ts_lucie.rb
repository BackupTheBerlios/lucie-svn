# = A suite rolling up all the tests.
#
# $Id: ts_lucie.rb 14 2005-01-19 06:32:24Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 1.1 $
# License::  GPL2

$LOAD_PATH.unshift '../lib'

require 'test/unit/testsuite'
require 'test/unit/ui/Tk/testrunner'

# automatically collect all the tests and run them.
class AllTests
  public
  def initialize
    testsuite = setup_testsuite
    @testrunner = Test::Unit::UI::Tk::TestRunner.new( testsuite )
  end

  public
  def run
    @testrunner.start
  end

  private
  def setup_testsuite
    Dir.glob( "tc_*.rb" ).sort.each do |each|
      require each
    end
    testsuite = Test::Unit::TestSuite.new( "Lucie testsuite" )
    ObjectSpace.each_object( Class ) do |klass|  
      testsuite << klass.suite if testcase?( klass )
    end
    return testsuite
  end
    
  private
  def testcase?( klass )
    return (klass < Test::Unit::TestCase) && (/\ATC_/=~ klass.name)
  end
end

AllTests.new.run

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
