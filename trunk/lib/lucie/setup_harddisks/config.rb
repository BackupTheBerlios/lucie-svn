# = setup_harddisks �f�B�X�N��`�p���C�u����
#
# Lucie ���\�[�X�ݒ�t�@�C�� <code>/etc/lucie/partition.rb</code> �̐擪�ł��̃t�@�C����
# <code>require</code> ���邱�ƁB�ڂ����� <code>doc/example/partition.rb</code> ���Q�ƁB
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
