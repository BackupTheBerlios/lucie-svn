# = setup-harddisks ディスク定義用ライブラリ
#
# Lucie リソース設定ファイル <code>/etc/lucie/partition.rb</code> の先頭でこのファイルを
# <code>require</code> すること。詳しくは <code>doc/example/partition.rb</code> を参照。
#
# $Id: config.rb 548 2005-04-11 08:32:26Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $Revision: 548 $
# License::  GPL2

require 'lucie/setup-harddisks/partition'

Lucie::update(%q$Date: 2005-04-11 17:32:26 +0900 (Mon, 11 Apr 2005) $)

# ------------------------- Convenience methods.

def partition ( label, &block )
  return Lucie::SetupHarddisks::Partition.new( label, &block )
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
