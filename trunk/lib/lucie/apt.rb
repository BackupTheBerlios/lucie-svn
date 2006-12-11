#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


require 'lucie/shell'


class Apt
  attr_accessor :root


  def initialize command, &block
    block.call self
    Shell.new do | shell |
      shell.exec( { 'LC_ALL' => 'C' }, 'chroot', @root, 'apt-get', command )
    end
  end
end
