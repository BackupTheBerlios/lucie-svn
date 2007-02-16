#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie'
require 'lucie/shell'


class Apt
  def self.get command, option = nil
    self.new command.split( ' ' ), option
  end


  def self.clean option = nil
    self.new :clean, option
  end


  def self.update option = nil
    self.new :update, option
  end


  def self.check option = nil
    self.new :check, option
  end


  def initialize command, option = nil
    @env = { 'LC_ALL' => 'C' }
    case command
    when String, Symbol
      @command = [ command.to_s ]
    when Array
      @command = command
    end
    set_option option
    exec_shell
  end


  def child_status
    return @shell.child_status
  end


  private


  def set_option option
    return unless option
    if option[ :root ]
      @root = option[ :root ]
    end
    if option[ :env ]
      @env.merge! option[ :env ]
    end
  end


  def exec_shell
    if @root
      command_line = [ @env, 'chroot', @root, 'apt-get' ] + @command
    else
      command_line = [ @env, 'apt-get' ] + @command
    end

    @shell = Shell.open do | shell |
      shell.on_stdout do | line |
        Lucie.debug line
      end
      shell.on_stderr do | line |
        Lucie.error line
      end
      shell.exec *command_line
    end
  end
end


module Kernel
  def apt command, option
    return Apt.new( command, option )
  end


  def aptget_clean option = nil
    return apt( :clean, option )
  end
  module_function :aptget_clean


  def aptget_check option = nil
    return apt( :check, option )
  end
  module_function :aptget_check


  def aptget_update option = nil
    return apt( :update, option )
  end
  module_function :aptget_update
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
