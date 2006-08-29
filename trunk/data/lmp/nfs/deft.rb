#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# -------------------------

template( 'lucie-client/nfs/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-nfs setup wizard'
  template.short_description_ja = 'nfs $B$N%;%C%H%"%C%W%&%#%6!<%I$X$h$&$3$=(B'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate NFS (Network File Systewm) configuration.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  $B$3$N%&%#%6!<%I$G$O(B NFS (Network File System) $B$N@_Dj$r9T$$$^$9!#(B
  DESCRIPTION_JA
end

question( 'lucie-client/nfs/hello' => 'lucie-client/nfs/server' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/nfs/server' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure NFS Server'
  template.short_description_ja = 'NFS $B%5!<%P$N;XDj(B'
  template.extended_description = <<-DESCRIPTION
  Please input your nfs server address and an entry to be mounted separated by colon (:) .

  ( [Ex] nfs-server.example.com:/export/dir )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NFS $B%5!<%P$N%"%I%l%95Z$S%^%&%s%H$9$k%(%s%H%j$r%3%m%s(B(:)$B$G6h@Z$C$FF~NO$7$F$/$@$5$$!#(B

  ( [$BNc(B] nfs-server.example.com:/export/dir )
  DESCRIPTION_JA
end

question( 'lucie-client/nfs/server' => 'lucie-client/nfs/mount' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/nfs/mount' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure mount point'
  template.short_description_ja = '$B%^%&%s%H%]%$%s%H$N;XDj(B'
  template.extended_description = <<-DESCRIPTION
  Please input local mount point.

  ( [Ex] /mnt/dir )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  $B%m!<%+%k$N%^%&%s%H%]%$%s%H$r;XDj$7$F$/$@$5$$!#(B

  ( [$BNc(B] /mnt/dir )
  DESCRIPTION_JA
end

question( 'lucie-client/nfs/mount' => 'lucie-client/nfs/option' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# -------------------------

template( 'lucie-client/nfs/option' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure NFS mount option'
  template.short_description_ja = 'NFS ¥Þ¥¦¥ó¥È¥ª¥×¥·¥ç¥ó¤ÎÀßÄê'
  template.extended_description = <<-DESCRIPTION
  Input your NFS mount-option comma-delimited.
  
  ( [Ex.] rsize=8192,wsize=8192,nosuid )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NFS ¥Þ¥¦¥ó¥È¥ª¥×¥·¥ç¥ó¤ò¥«¥ó¥Þ¶èÀÚ¤ê¤ÇÆþÎÏ¤·¤Æ²¼¤µ¤¤¡£
  
  ( [Îã.] rsize=8192,wsize=8192,nosuid )
  DESCRIPTION_JA
end

question( 'lucie-client/nfs/option' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
