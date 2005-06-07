#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/lilo/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-lilo setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of lilo.

  NOTE: Lucie lilo script provided by this package may fail because of
  the lack of necessary libdevmapper shared library in nfsroot. In
  this case, please add libdevmapper1.01 (or 1.00) to the
  installer.extra_packages in /etc/lucie/resource.rb and re-run
  lucie-setup
  DESCRIPTION
  template.short_description_ja = 'lmp-lilo セットアップウィザードへようこそ'
  template.extended_description_ja = <<-DESCRIPTION_JA
  このメタパッケージは lilo の設定を Lucie サーバへ行います。

  注意: このメタパッケージによって提供される Lucie スクリプトは、
  nfsroot 上に必要な libdevmapper 共有ライブラリがインストールされてい
  ないために失敗する場合があります。この場合、/etc/lucie/resource.rb 
  の installer.extra_packages に libdevmapper1.01 (もしくは 1.00) を追
  加し、lucie-setup を再実行してください。
  DESCRIPTION_JA
end

question( 'lucie-client/lilo/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
