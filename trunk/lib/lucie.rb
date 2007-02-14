#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'logger'


module Lucie
  PINK = {:console => "[0;31m", :html => "FFA0A0"}
  GREEN = {:console => "[0;32m", :html => "00CD00"}
  YELLOW = {:console => "[0;33m", :html => "FFFF60"}
  SLATE = {:console => "[0;34m", :html => "80A0FF"}
  ORANGE = {:console => "[0;35m", :html => "FFA500"}
  BLUE = {:console => "[0;36m", :html => "40FFFF"}
  RESET = {:console => "[0m", :html => ""}


  @@colormap = {
    :fatal => PINK,
    :error => YELLOW,
    :warn => ORANGE,
    :info => GREEN,
    :debug => SLATE
  }


  def console_color(level, str)
    @@colormap[level][:console] + str + RESET[:console]
  end
  module_function :console_color


  def fatal message
    puts console_color( :fatal, "%s: %s" % [ :fatal, message ])
  end
  module_function :fatal


  def error message
    puts console_color( :error, "%s: %s" % [ :error, message ])
  end
  module_function :error


  def warn message
    puts console_color( :warn, "%s: %s" % [ :warn, message ])
  end
  module_function :warn


  def info message
    puts console_color( :info, "%s: %s" % [ :info, message ])
  end
  module_function :info


  def debug message
    puts console_color( :debug, "%s: %s" % [ :debug, message ])
  end
  module_function :debug
end
