#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'
require 'lucie/time-stamp'

module Lucie
  update(%q$Id$)

  module Config
    class DiffInstaller < Resource
      # ��Ͽ����Ƥ��� Host �Υꥹ��
      @@list = {}

      # ���ȥ�ӥ塼��̾�Υꥹ��: [:name, :version, ...]
      @@required_attributes = []
      
      # _���٤Ƥ�_ ���ȥ�ӥ塼��̾�ȥǥե�����ͤΥꥹ��: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # ���ȥ�ӥ塼��̾����ǥե�����ͤؤΥޥåԥ�
      @@default_value = {}

      required_attribute :name
      required_attribute :installers
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:

