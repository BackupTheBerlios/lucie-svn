#
# $Id: installer-base-task.rb 460 2005-03-28 08:58:11Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 460 $
# License::  GPL2

require 'log4r'
require 'lucie/time-stamp'
require 'open3'

module Lucie
  update(%q$Date$)

  class Logger < Log4r::Logger
    include Singleton

    public
    def initialize
      super( 'lucie-setup' )
      @outputters = 
        [Log4r::FileOutputter.new( 'lucie-setup',
                                   {:filename=>'/var/log/lucie-setup.log'} )]
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

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
