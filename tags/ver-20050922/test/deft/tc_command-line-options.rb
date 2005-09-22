# = TestUnit for commandline option class.
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/command-line-options'
require 'test/unit'

class TC_CommandLineOptions < Test::Unit::TestCase
  public
  def setup
    @commandline_options = Deft::CommandLineOptions.instance
  end
  
  public
  def test_parse_returns_nil
    assert_nil( @commandline_options.parse( [] ),
                "return value of the method parse was not nil" )
  end
  
  # コマンドラインオプションのデフォルト値のテスト ###################
  
  # デフォルトで trace オプションがオフであることをテスト
  public
  def test_default_trace_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.trace,
                  "default value for trace option was not set to OFF" )
  end
  
  # デフォルトで help オプションがオフであることをテスト
  public
  def test_default_help_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.help,
                  "default value for help option was not set to OFF" )
  end
  
  # デフォルトで version オプションがオフであることをテスト
  public
  def test_default_version_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.version,
                  "defalut value for version was not set to OFF" )
  end
  
  # デフォルトで run オプションが nil であることをテスト
  public
  def test_default_run_option_is_false
    @commandline_options.parse( [] )
    assert_nil( @commandline_options.run,
                "defalut value for run was not set to OFF" )
  end
  
  # デフォルトで template オプションが false であることをテスト
  public
  def test_default_template_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.template,
                  "defalut value for template was not set to OFF" )
  end 
  
  # デフォルトで question オプションが false であることをテスト
  public
  def test_default_template_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.question,
                  "defalut value for question was not set to OFF" )
  end 
  
  # 実際にコマンドラインオプションをパーズし、値が取得できるかどうかのテスト ##############
  
  public
  def test_parse_trace_option
    @commandline_options.parse( ['--trace'] )
    assert( @commandline_options.trace, "couldn't get value for trace option" )
  end
  
  public
  def test_parse_help_option
    @commandline_options.parse( ['--help'] )
    assert( @commandline_options.help, "couldn't get value for help option" )
  end
  
  public
  def test_parse_version_option
    @commandline_options.parse( ['--version'] )
    assert( @commandline_options.version, "couldn't get value for version option" )
  end
  
  public
  def test_parse_run_option
    @commandline_options.parse( ['--run=data/lucie_vm_template'] )
    assert_equal( 'data/lucie_vm_template', @commandline_options.run,
                  "couldn't get value for run option" )
  end
  
  public
  def test_parse_template_option
    @commandline_options.parse( ['--template=foo/bar'] )
    assert_equal( 'foo/bar', @commandline_options.template,
                  "couldn't get value for template option" )
  end
  
  public
  def test_parse_question_option
    @commandline_options.parse( ['--question=foo/bar'] )
    assert_equal( 'foo/bar', @commandline_options.question,
                  "couldn't get value for question option" )
  end
  
  # その他のテスト ###################################################################
  
  public
  def test_OPTION_LIST
    assert( Deft::CommandLineOptions::OptionList.const_defined?( :OPTION_LIST ),
            "const OPTION_LIST was not defined" )
    assert_kind_of( Array, Deft::CommandLineOptions::OptionList::OPTION_LIST,
            "const OPTION_LIST was not an Array" )
    Deft::CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
      assert_match( /\A--[0-9A-Za-z\-_]+\Z/, long, "long option was in wrong format" )
      assert_match( /\A-\w\Z/, short, "short option was in wrong format" )
      assert_kind_of( String, arg, "arg was not a String" ) unless arg.nil?
      assert_kind_of( String, desc, "desc was not a String" )
    end
  end

  public
  def test_options
    options = Deft::CommandLineOptions::OptionList.options
    assert_kind_of Array, options
    options.each do |long, short, getopt_option| 
      assert_match( /^--[0-9A-Za-z\-_]+$/, long, "long option was in wrong format" )
      assert_match( /^-\w$/, short, "short option was in wrong format" )
      assert( (getopt_option == GetoptLong::REQUIRED_ARGUMENT) ||
              (getopt_option == GetoptLong::NO_ARGUMENT),
              "getopt option must be GetoptLong::REQUIRED_ARGUMENT or GetoptLong::NO_ARGUMENT" )
    end
  end
  
  public
  def test_parse_wrong_command_line_option_raises_exception
    assert_raises( GetoptLong::InvalidOption, "getoptlong exception was not raised" ) do 
      @commandline_options.parse( ['--WRONG-OPTION'] )
    end
  end
  
  public
  def test_parse_argument_notrequired_option_with_argument_raises_exception
    assert_raises( GetoptLong::NeedlessArgument, "getoptlong exception was not raised" ) do 
      @commandline_options.parse( ['--help=NEEDLESS_ARGUMENT'] )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
