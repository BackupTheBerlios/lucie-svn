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
    #
    # ���󥹥ȡ���֤κ�ʬ�ȶ�����ʬ��������뤿��Υ��饹��
    #
    # <b>���󥹥ȡ���:</b> +installer_A+, +installer_B+, +installer_C+, ...
    # 
    # �����ä���硢�ƥ��󥹥ȡ���֤κ�ʬ & ������ʬ���󥹥ȡ����ʲ��Τ褦������Ǥ��롣
    #
    #  Lucie::Config::DiffInstaller.new do |diff_installer|
    #    diff_installer.name = 'hotswap_node'
    #    diff_installer.installers = [Installer['installer_A'], Installer['installer_B'], ...]
    #  end
    #  
    #  or 
    # 
    #  # û�������С������
    #  diff_installer do |diff_installer|
    #    diff_installer.name = 'hotswap_node'
    #    diff_installer.installers = [Installer['installer_A'], Installer['installer_B'], ...]
    #  end
    #
    # ���ξ�硢���̥��󥹥ȡ���Ȥ��� +hotswap_node+ ������Ū�������
    # ��롣�ޤ������̥��󥹥ȡ��餫��ƥ��󥹥ȡ���ؤκ�ʬ���󥹥ȡ�
    # �餬�Ť�
    #
    # * +hotswap_node_to_installer_A+, +hotswap_node_to_installerB+, ...
    #
    # �Ȥ���̾�����������롣
    #
    class DiffInstaller < Resource
      # ��Ͽ����Ƥ��� DiffInstaller �Υꥹ��
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

