#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

require 'lucie/nfsroot-task'

if %x{cat #{Rake::NfsrootTask::CONFIGURATION_NAME_STAMP}} == %x{cat #{Rake::NfsrootTask::INSTALLER_NAME_STAMP}}
  sh( %{setup_harddisks -f /etc/lucie/partition -d -X > #{$format_log} 2>&1}, $sh_option )
else
  sh( %{setup_harddisks -f /etc/lucie/partition -d > #{$format_log} 2>&1}, $sh_option )
end

# TODO: $diskvar が生成されなかった場合のエラー処理
# TODO: setup_harddisks の再実装

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
