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


  def self.open &block
    shell = self.new
    return shell.open( &block )
  end


  def open &block
    block.call self
    return self
  end


  def initialize
    @shell = Shell.new
  end


  # Do exec command in chroot environment, and delegate other methods
  # to Shell object.
  def exec env, *command
    @shell.exec env, 'chroot', @root, *command
  end


  def method_missing message, *arg
    @shell.__send__ message, *arg
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
