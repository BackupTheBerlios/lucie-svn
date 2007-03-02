#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'flexmock'
require 'install-packages/command'
require 'test/unit'


class TC_Command < Test::Unit::TestCase
  class DummyClass
    include InstallPackages::Command
  end


  def test_not_implemented_error
    assert_raises( NotImplementedError ) do
      DummyClass.new.execute
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
