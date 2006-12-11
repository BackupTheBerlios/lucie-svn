#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift './lib'


require 'lucie/shell'


class ChrootShell
  attr_accessor :root


  def initialize &block
    @shell = Shell.new
    block.call self
  end


  def method_missing message, *arg
    @shell.__send__ message, *arg
  end


  def exec env, *command
    @shell.exec env, 'chroot', @root, *command
  end
end
