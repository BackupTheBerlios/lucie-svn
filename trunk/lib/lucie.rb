#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'logger'


module Lucie
  @@log = Logger.new( STDOUT )


  def fatal message
    @@log.fatal message
  end
  module_function :fatal


  def error message
    @@log.error message
  end
  module_function :error


  def warn message
    @@log.warn message
  end
  module_function :warn


  def info message
    @@log.info message
  end
  module_function :info


  def debug message
    @@log.debug message
  end
  module_function :debug
end
