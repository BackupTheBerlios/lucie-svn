#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

sh( %{install_packages </dev/null >> #{$software_log} 2>&1}, $sh_option )

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
