#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie/shell'


class Apt
  attr_accessor :root


  def initialize command, &block
    @command = command.to_s
    if block
      block.call self
    end
    exec_shell
  end


  def child_status
    return @shell.child_status
  end


  private


  def exec_shell
    if @root
      @shell = Shell.new do | shell |
        shell.exec( { 'LC_ALL' => 'C' }, 'chroot', @root, 'apt-get', @command )
      end
    else
      @shell = Shell.new do | shell |
        shell.exec( { 'LC_ALL' => 'C' }, 'apt-get', @command )
      end
    end
  end
end


# Abbreviations
module Kernel
  def apt command, &block
    if block
      return Apt.new( command, &block )
    else
      return Apt.new( command )
    end
  end
  module_function :apt
end
