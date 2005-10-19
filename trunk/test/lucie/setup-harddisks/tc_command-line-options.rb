#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift 'trunk/lib'

require 'test/unit'
require 'lucie/setup-harddisks/command-line-options'

include Lucie::SetupHarddisks

class TC_CommandLineOptions < Test::Unit::TestCase
  public
  def setup
    @options = CommandLineOptions.instance
  end
  
  public
  def test_default_options
    test_argv = [ ]
    @options.parse test_argv
    assert_equal( false, @options.no_test )
    assert_equal( '/etc/lucie/partition.rb', @options.config_file )
    assert_equal( '/tmp/lucie', @options.log_dir )
    assert_equal( true, @options.dos_alignment )
    assert_equal( false, @options.verbose )
    assert_equal( false, @options.help)
  end
  
  public
  def test_long_optoins
    test_argv = ["--no-test", "--config-file", "test.conf", "--log-dir", "/var/tmp", "--dos-alignment", "--verbose", "--help" ]
    @options.parse test_argv
    assert_equal( true, @options.no_test)
    assert_equal( "test.conf", @options.config_file )
    assert_equal( "/var/tmp", @options.log_dir )
    assert_equal( false, @options.dos_alignment )
    assert_equal( true, @options.verbose )
    assert_equal( true, @options.help )
  end
  
  public
  def test_short_options
    test_argv = ["-X", "-f", "test.conf", "-l", "/var/tmp", "-d", "-v", "-h" ]
    @options.parse test_argv
    assert_equal( true, @options.no_test)
    assert_equal( "test.conf", @options.config_file )
    assert_equal( "/var/tmp", @options.log_dir )
    assert_equal( false, @options.dos_alignment )
    assert_equal( true, @options.verbose )
    assert_equal( true, @options.help )
  end

  public
  def test_short_options2
    test_argv = ["-X", "-ftest.conf", "-l/var/tmp", "-d", "-v", "-h" ]
    @options.parse test_argv
    assert_equal( true, @options.no_test)
    assert_equal( "test.conf", @options.config_file )
    assert_equal( "/var/tmp", @options.log_dir )
    assert_equal( false, @options.dos_alignment )
    assert_equal( true, @options.verbose )
    assert_equal( true, @options.help )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: