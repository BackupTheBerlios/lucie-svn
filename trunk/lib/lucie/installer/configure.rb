#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# TODO: fai-do-scripts ¤ÎºÆ¼ÂÁõ
classes = Dir.entries('/etc/lucie/script') - ['.', '..']
kernel_package = (Dir.entries('/etc/lucie/kernel') - ['.', '..']).first
sh %{classes="#{classes.join(' ')}" cfclasses="#{classes.join('.')}" kernel_package="#{kernel_package}" rootpw="#{installer_resource.root_password}" fai-do-scripts -L #{$logdir} /etc/lucie/script}

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
