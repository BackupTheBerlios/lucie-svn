#
# $Id: installer-base-task.rb 460 2005-03-28 08:58:11Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 460 $
# License::  GPL2

require 'log4r'
require 'lucie/command-line-options'
require 'lucie/time-stamp'
require 'open3'

module Lucie
  update(%q$Date$)

  class Logger < Log4r::Logger
    include Singleton

    public
    def initialize
      super( 'lucie-setup', CommandLineOptions.instance.logging_level )
      @outputters = 
        [Log4r::FileOutputter.new( 'lucie-setup',
                                   {:filename=>CommandLineOptions.instance.log_file} )]
    end
  end
end

module FileUtils
  def sh_log(*cmd, &block)
    if Hash === cmd.last then
      options = cmd.pop
    else
      options = {}
    end
    fu_check_options options, :noop, :verbose
    Lucie::Logger.instance.info cmd.join(' ')
    fu_output_message cmd.join(' ') if options[:verbose]
    IO.popen(cmd.join(' '), &block) unless options[:noop]
  end
end

# a thin wrapper for FileUtils.sh
def sh(*cmd, &block)
  if Hash === cmd.last
    Lucie::Logger.instance.info cmd[0..cmd.size-2].join(' ')
  else
    Lucie::Logger.instance.info cmd.join(' ')
  end
  return FileUtils.sh( *cmd, &block )
end

# a thin wrapper for FileUtils.rm_f
def rm_f( list, options={} ) 
  Lucie::Logger.instance.info( "rm#{options[:force] ? ' -f' : ''} #{[list].flatten.join ' '}" )
  return FileUtils.rm_f( list, options )
end

# a thin wrapper for FileUtils.rm_r
def rm_r( list, options={} )
  Lucie::Logger.instance.info("rm -r#{options[:force] ? 'f' : ''} #{[list].flatten.join ' '}")
  return FileUtils.rm_r( list, options )
end

# a thin wrapper for FileUtils.rm_rf
def rm_rf( list, options={} )
  options = options.dup
  options[:force] = true
  return rm_r( list, options )
end

# a thin wrapper for FileUtils.mkdir_p
def mkdir_p( list, options={} )
  Lucie::Logger.instance.info("mkdir -p #{options[:mode] ? ('-m %03o ' % options[:mode]) : ''}#{[list].flatten.join ' '}")
  return FileUtils.mkdir_p( list, options )
end

# a thin wrapper for FileUtils.cp
def cp( src, dest, options={} )
  Lucie::Logger.instance.info( "cp#{options[:preserve] ? ' -p' : ''} #{[src,dest].flatten.join ' '}" )
  return FileUtils.cp( src, dest, options )
end

# a thin wrapper for FileUtis.touch
def touch( list, options={} )
  Lucie::Logger.instance.info( "touch #{[list].flatten.join ' '}" )
  return FileUtils.touch( list,options )
end

# a thin wrapper for FileUtis.rmdir
def rmdir( list, options={} )
  Lucie::Logger.instance.info( "rmdir #{[list].flatten.join ' '}" )
  return FileUtils.rmdir( list, options )
end

# a thin wrapper for FileUtis.ln_s
def ln_s( src, dest, options={} )
  Lucie::Logger.instance.info "ln -s#{options[:force] ? 'f' : ''} #{[src,dest].flatten.join ' '}"
  return FileUtils.ln_s( src, dest, options )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
