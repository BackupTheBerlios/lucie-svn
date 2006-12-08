require 'lucie/shell'


class Debootstrap
  attr_accessor :env
  attr_accessor :exclude
  attr_accessor :suite
  attr_accessor :target
  attr_accessor :mirror


  def option
    yield self
  end


  def commandline
    return [ '/usr/sbin/debootstrap', "--exclude=#{ @exclude.join(',') }", @suite, @target, @mirror ]
  end
end


class DebootstrapRunner
  def load_option debconf
    @debconf = debconf
  end


  # [TODO] 終了処理 (正常、エラー)
  def run
    shell = Shell.new
    shell.open do | shell |
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
      shell.exec @debconf.env, *@debconf.commandline
    end
  end
end
