#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie'
require 'lucie/shell'


# [TODO] debootstrap �����顼��λ���˥ǥե���Ȥ��㳰�� raise ����褦�ˤ���
class Debootstrap
  @@debootstrap_version = nil


  class DebootstrapOption
    attr_accessor :env
    attr_accessor :exclude
    attr_accessor :include
    attr_accessor :mirror
    attr_accessor :suite
    attr_accessor :target


    def commandline
      return [ '/usr/sbin/debootstrap', "--exclude=#{ @exclude.join( ',' ) }", "--include=#{ @include.join( ',' ) }", @suite, @target, @mirror ]
    end
  end


  # [TODO] �С�����󤬼����Ǥ��ʤ������㳰�� raise ����褦�ˤ���
  def self.VERSION
    Shell.open do | shell |
      shell.on_stdout do | line |
        if /^\S\S\s+debootstrap\s+(\S+)/=~ line
          @@debootstrap_version = $1
        end
      end
      shell.exec( { 'LC_ALL' => 'C' }, 'dpkg', '-l' )
    end
    return @@debootstrap_version
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
    error_message = []

    @shell = Shell.open do | shell |
      Thread.new do
        loop do
          shell.puts
        end
      end

      shell.on_stdout do | line |
        Lucie.debug line
      end

      shell.on_stderr do | line |
        case line
        when /\Aln: \S+ File exists/
          raise RuntimeError, line
        end
        Lucie.error line
        error_message.push line
      end

      shell.on_failure do
        raise RuntimeError, error_message.last
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
