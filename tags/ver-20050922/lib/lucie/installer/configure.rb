#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# TODO: fai-do-scripts ¤ÎºÆ¼ÂÁõ
classes = (Dir.entries($script_dir) - ['.', '..']).sort
if classes.size == 0
  puts "No configuration script were found."
else
  kernel_package = (Dir.entries($kernel_dir) - ['.', '..']).first
  sh %{classes="#{classes.join(' ')}" cfclasses="#{classes.join('.')}" kernel_package="#{kernel_package}" rootpw="#{installer_resource.root_password}" fai-do-scripts -L #{$logdir} /etc/lucie/script}
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
