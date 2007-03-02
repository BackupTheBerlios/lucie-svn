#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


module InstallPackages
  module PackageManager
    def execute shell, env, command, dryRun
      if dryRun
        # [XXX] ‰½‚ç‚©‚Ì Logger ‚Åo—Í‚·‚é
        STDOUT.puts " ENV{ ``LC_ALL'' => ``C'' } #{ command.join( ' ' ) }"
      else
        shell.exec env, command
      end
    end


    def default_env
      return { 'LC_ALL' => 'C' }
    end


    def chroot_command
      return [ 'chroot', '/tmp/target' ]
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
