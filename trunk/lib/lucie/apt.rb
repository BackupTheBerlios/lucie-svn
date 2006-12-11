#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


require 'lucie/shell'


class AptOption
  attr_accessor :root


  def initialize
    yield self
  end
end


class Apt
  def initialize option
    @option = option
  end


  def clean
    Shell.new do | shell |
      shell.exec( { 'LC_ALL' => 'C' }, 'chroot', @option.root, 'apt-get', 'clean' )
    end
  end
end
