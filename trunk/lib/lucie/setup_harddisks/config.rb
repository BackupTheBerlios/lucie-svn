# = setup_harddisks ディスク定義用ライブラリ
#
# Lucie リソース設定ファイル <code>/etc/lucie/partition.rb</code> の先頭でこのファイルを
# <code>require</code> すること。詳しくは <code>doc/example/partition.rb</code> を参照。
#
# $Id: config.rb 957 2005-10-19 07:15:53Z sakae $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $Revision: 957 $
# License::  GPL2

require 'lucie/setup_harddisks/partition'

Lucie::update(%q$Date: 2005-10-19 16:15:53 +0900 (Wed, 19 Oct 2005) $)

# ------------------------- Convenience methods.

def partition ( label, &block )
  return Lucie::SetupHarddisks::Partition.new( label, &block )
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
