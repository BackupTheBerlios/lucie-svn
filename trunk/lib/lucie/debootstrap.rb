#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie/shell'


# [TODO] debootstrap �����顼��λ���˥ǥե���Ȥ��㳰�� raise ����褦�ˤ���
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


  # [TODO] �С�����󤬼����Ǥ��ʤ������㳰�� raise ����褦�ˤ���
  def self.VERSION
    Shell.open do | shell |
      shell.on_stdout do | line |
        if /^\S\S\s+debootstrap\s+(\S+)/=~ line
          return $1
        end
      end
      shell.exec( { 'LC_ALL' => 'C' }, 'dpkg', '-l' )
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
    @shell = Shell.open do | shell |
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
