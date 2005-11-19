#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

def method_renamed(h)
  old_name = h.keys[0].to_sym
  new_name = h.values[0].to_sym
  define_method(old_name) { |*args|
    file, line = caller[1].split(':')
    warning = "##{old_name} renamed to ##{new_name}"
    $stderr.puts "#{file}:#{line}: #{warning}"
    send(new_name, *args)
  }
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
