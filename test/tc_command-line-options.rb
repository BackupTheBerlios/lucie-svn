#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/command-line-options'
require 'test/unit'

class TC_CommandLineOptions < Test::Unit::TestCase
  public
  def setup
    @commandline_options = Lucie::CommandLineOptions.instance
  end
  
  public
  def test_parse_returns_nil
    assert_nil( @commandline_options.parse( [] ), "return value of the method parse was not nil" )
  end
  
  # コマンドラインオプションのデフォルト値のテスト ###################
  
  # デフォルトで template-directory オプションの値が /var/lib/lucie/template であることをテスト
  public
  def test_default_template_directory_option
    @commandline_options.parse( [] )
    assert_equal( '/var/lib/lucie/template', @commandline_options.template_directory, "default value for template-directory option was not set to OFF" )
  end
  
  # デフォルトで trace オプションがオフであることをテスト
  public
  def test_default_trace_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.trace, "default value for trace option was not set to OFF" )
  end
  
  # デフォルトで dryrun オプションがオフであることをテスト
  public
  def test_default_dryrun_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.dryrun, "default value for dryrun option was not set to OFF" )
  end
  
  # デフォルトで debug オプションがオフであることをテスト
  public
  def test_default_debug_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.debug, "default value for debug option was not set to OFF" )
  end
  
  # デフォルトで help オプションがオフであることをテスト
  public
  def test_default_help_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.help, "default value for help option was not set to OFF" )
  end
  
  # デフォルトで installer-name オプションがセットされていないことをテスト
  public
  def test_default_installer_name_option_is_nil
    @commandline_options.parse( [] )
    assert_nil( @commandline_options.installer_name, "default value for installer-name option was not set to nil" )
  end
  
  # デフォルトで list-resource オプションがセットされていないことをテスト
  public
  def test_default_list_resource_option_is_nil
    @commandline_options.parse( [] )
    assert_nil( @commandline_options.list_resource, "default value for list-reource option was not set to nil" )
  end
  
  # デフォルトで make-floppy オプションがオフであることをテスト
  public
  def test_default_make_floppy_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.make_floppy, "default value for make-floppy option was not set to OFF" )
  end
  
  # デフォルトで skip-verification オプションがオフであることをテスト
  public
  def test_default_skip_verfication_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.skip_verification, "default value for skip-verification option was not set to OFF")
  end
  
  # デフォルトで ui-type オプションの値が :console であることをテスト
  public
  def test_default_ui_type_option_is_console
    @commandline_options.parse( [] )
    assert_equal( :console, @commandline_options.ui_type, "defalut value for ui-type option was not set to :console" )
  end
  
  # デフォルトで version オプションがオフであることをテスト
  public
  def test_default_version_option_is_false
    @commandline_options.parse( [] )
    assert_equal( false, @commandline_options.version, "defalut value for version was not set to OFF" )
  end
  
  # 実際にコマンドラインオプションをパーズし、値が取得できるかどうかのテスト ##############
  
  public
  def test_template_directory_option
    @commandline_options.parse( ['--template-directory=c:\tmp'] )
    assert_equal 'c:\tmp', @commandline_options.template_directory, "couldn't get value for --template-directory option"
  end
  
  public
  def test_parse_trace_option
    @commandline_options.parse( ['--trace'] )
    assert( @commandline_options.trace, "couldn't get value for --trace option" )
  end
  
  public
  def test_parse_dryrun_option
    @commandline_options.parse( ['--dryrun'] )
    assert( @commandline_options.dryrun, "couldn't get value for --dryrun option" )
  end
  
  public
  def test_parse_make_floppy_option
    @commandline_options.parse( ['--make-floppy'] )
    assert( @commandline_options.make_floppy, "couldn't get value for --make-floppy option" )
  end
  
  public
  def test_parse_ui_type_option
    @commandline_options.parse( ['--ui-type=tk'] )
    assert_equal( :tk, @commandline_options.ui_type, "couldn't get value for --ui-type option" )
  end
  
  public
  def test_parse_skip_verification_option
    @commandline_options.parse( ['--skip-verification'] )
    assert( @commandline_options.skip_verification, "couldn't get value for --skip-verification option" )
  end
  
  public
  def test_parse_list_resource_option
    @commandline_options.parse( ['--list-resource=installer'] )
    assert_equal( :installer, @commandline_options.list_resource, "couldn't get value for list-resource option" )
  end
  
  public
  def test_parse_installer_name_option
    @commandline_options.parse( ['--installer-name=TEST_INSTALLER'] )
    assert_equal( :TEST_INSTALLER, @commandline_options.installer_name, "couldn't get value for installer-name option" )
  end
  
  public
  def test_parse_debug_option
    @commandline_options.parse( ['--debug'] )
    assert( @commandline_options.debug, "couldn't get value for debug option" )
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
  
  # その他のテスト ###################################################################
  
  # inspect メソッドのテスト
  public
  def test_inspect
    assert_match( /\A\[CommandLineOptions:\s*(\S+=\S+\s*)+\]\Z/, @commandline_options.inspect, "bad format of inspection String" )
    assert_match( /debug=(true|false)/, @commandline_options.inspect, "couldn't inspect debug option" )
    assert_match( /help=(true|false)/, @commandline_options.inspect, "couldn't inspect help option" )
    assert_match( /installer-name=\S+/,  @commandline_options.inspect, "couldn't inspect installer-name option" )
    assert_match( /list-resource=\S+/,  @commandline_options.inspect, "couldn't inspect list-resource option" )
    assert_match( /make-floppy=(true|false)/,  @commandline_options.inspect, "couldn't inspect make-floppy option" )
    assert_match( /skip-verification=(true|false)/,  @commandline_options.inspect, "couldn't inspect skip-verification option" )
    assert_match( /ui-type=(:console|:gtk)/,  @commandline_options.inspect, "couldn't inspect ui-type option" )
    assert_match( /version=(true|false)/,  @commandline_options.inspect, "couldn't inspect version option" )
    assert_match( /dryrun=(true|false)/,  @commandline_options.inspect, "couldn't inspect dryrun option" )
    assert_match( /trace=(true|false)/,  @commandline_options.inspect, "couldn't inspect trace option" )
    assert_match( /template-directory=\S+/,  @commandline_options.inspect, "couldn't inspect template-directory option" )
  end
  
  # OptionList::OPTION_LIST の形式が正しいことをテスト
  public
  def test_OPTION_LIST
    assert( Lucie::CommandLineOptions::OptionList.const_defined?( :OPTION_LIST ), "const OPTION_LIST was not defined" )
    assert_kind_of( Array, Lucie::CommandLineOptions::OptionList::OPTION_LIST, "const OPTION_LIST was not an Array" )
    Lucie::CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
      assert_match( /\A--[0-9A-Za-z\-_]+\Z/, long, "long option was in wrong format" )
      assert_match( /\A-\w\Z/, short, "short option was in wrong format" )
      assert_kind_of( String, arg, "arg was not a String" ) unless arg.nil?
      assert_kind_of( String, desc, "desc was not a String" )
    end
  end
  
  # OptionList モジュールから得られるオプションのリストの形式が正しいことをテスト
  public
  def test_options
    options = Lucie::CommandLineOptions::OptionList.options
    assert_kind_of Array, options
    options.each do |long, short, getopt_option| 
      assert_match( /^--[0-9A-Za-z\-_]+$/, long, "long option was in wrong format" )
      assert_match( /^-\w$/, short, "short option was in wrong format" )
      assert( (getopt_option == GetoptLong::REQUIRED_ARGUMENT) || (getopt_option == GetoptLong::NO_ARGUMENT),
              "getopt option must be GetoptLong::REQUIRED_ARGUMENT or GetoptLong::NO_ARGUMENT" )
    end
  end
  
  # 間違ったオプションを師弟した場合に例外が raise されることを確認
  public
  def test_parse_wrong_command_line_option_raises_exception
    assert_raises( GetoptLong::InvalidOption, "getoptlong exception was not raised" ) do 
      @commandline_options.parse( ['--WRONG-OPTION'] )
    end
  end
  
  # 引数があるはずのオプションに引数を指定しなかった場合に例外が raise されることを確認
  public
  def test_parse_argument_required_option_with_noargument_raises_exception
    assert_raises( GetoptLong::MissingArgument, "getoptlong exception was not raised" ) do 
      @commandline_options.parse( ['--installer-name'] )
    end
  end
  
  # 引数が無いはずのオプションに引数を指定した場合に例外が raise されることを確認
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
