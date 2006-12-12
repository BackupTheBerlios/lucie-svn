#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie/shell'


# [TODO] debootstrap がエラー終了時にデフォルトで例外を raise するようにする
class Debootstrap
  class DebootstrapOption
    attr_accessor :env
    attr_accessor :exclude
    attr_accessor :suite
    attr_accessor :target
    attr_accessor :mirror


    def commandline
      return [ '/usr/sbin/debootstrap', "--exclude=#{ @exclude.join(',') }", @suite, @target, @mirror ]
    end
  end


  def initialize
    @option = DebootstrapOption.new
    yield self
    exec_shell
  end


  def child_status
    return @shell.child_status
  end


  def method_missing message, *arg
    @option.__send__ message, *arg
  end


  private


  def exec_shell
    @shell = Shell.new do | shell |
      Thread.new do
        loop do
          shell.puts
        end
      end
      shell.on_stdout do | line |
        STDOUT.puts line
      end
      shell.on_stderr do | line |
        STDERR.puts line
      end
      shell.exec @option.env, *@option.commandline
    end
  end
end


# Abbrebiations
module Kernel
  def debootstrap &block
    Debootstrap.new &block
  end
  module_function :debootstrap
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
