#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lmp/builder'
require 'test/unit'

class TC_Builder < Test::Unit::TestCase
  public
  def test_build
    spec = Mock.new( '[SPEC]' )
    spec.__next( :builddir ) do 'test/lmp/build' end
    spec.__next( :builddir ) do 'test/lmp/build' end
    spec.__next( :name ) do 'lmp-test' end 
    spec.__next( :readme ) do end 
    spec.__next( :changelog ) do end
    spec.__next( :config ) do end
    spec.__next( :control ) do end
    spec.__next( :copyright ) do end
    spec.__next( :postinst ) do end
    spec.__next( :rules ) do end
    spec.__next( :templates ) do end
    builder = LMP::Builder.new( spec )
    builder.build
    
    assert( FileTest.directory?( 'test/lmp/build' ), 'ビルドディレクトリができていない' )
    assert( FileTest.directory?( 'test/lmp/build/lmp-test/debian' ), 'debian ディレクトリができていない' )
    test_debian_package_file( 'README.Debian' )
    test_debian_package_file( 'changelog' )
    test_debian_package_file( 'config' )
    test_debian_package_file( 'control' )
    test_debian_package_file( 'copyright' )
    test_debian_package_file( 'postinst' )
    test_debian_package_file( 'rules' )
    test_debian_package_file( 'templates' )

    assert( FileTest.exist?( 'build/lmp-test.deb' ), 'lmp ができていない' )
  end
  
  private
  def test_debian_package_file( fileNameString )
    assert( FileTest.exists?( "test/lmp/build/lmp-test/debian/#{fileNameString}" ), "#{fileNameString} ファイルができていない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
