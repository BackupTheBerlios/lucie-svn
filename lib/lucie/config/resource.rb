#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Lucie
  module Config
    # ���ׂẴ��\�[�X�N���X
    # * �z�X�g (Host)
    # * �z�X�g�O���[�v (HostGroup)
    # * �p�b�P�[�W�T�[�o (PackageServer)
    # * DHCP �T�[�o (DHCPServer)
    # * �C���X�g�[�� (Installer)
    # �̐e�ƂȂ�N���X�B
    #
    # �q�ƂȂ郊�\�[�X�N���X�́A�ȉ��̃N���X�ϐ������K�v������
    # * �o�^����Ă��郊�\�[�X�I�u�W�F�N�g�̃��X�g: <code>@@list = []</code>
    # * �A�g���r���[�g���̃��X�g: <code>@@required_attributes = []</code>
    # * ���ׂẴA�g���r���[�g���ƃf�t�H���g�l�̃��X�g: <code>@@attributes = []</code>
    # * �A�g���r���[�g������f�t�H���g�l�ւ̃}�b�s���O: <code>@@default_value = {}</code>
    #
    class Resource  
      # ------------------------- Convenience class methods.

      # �o�^����Ă��郊�\�[�X���N���A����
      public
      def self.clear
        module_eval %-
          @@list.clear
        -
      end

      # �����̖��O��Ԃ�
      public
      def self.attribute_names
        module_eval %-
          @@attributes.map { |name, default| name }
        -
      end
      
      # <code>[����, �f�t�H���g�l]</code> �̔z���Ԃ�
      public
      def self.attribute_defaults
        module_eval %-
          @@attributes.dup
        -
      end
      
      # ���� <code>name</code> �ɑΉ�����f�t�H���g�l��Ԃ�
      public
      def self.default_value( name )
        module_eval %-
          @@default_value[:#{name}]
        -
      end
      
      # �K�{������Ԃ�
      public
      def self.required_attributes
        module_eval %-
          @@required_attributes.dup
        -
      end
      
      # ���� <code>name</code> ���K�{�����ł��邩�ǂ�����Ԃ�
      public
      def self.required_attribute?( name )
        module_eval %-
          @@required_attributes.include? :#{name}
        -
      end    
      
      # ------------------------- Infrastructure class methods.

      # �o�^����Ă��郊�\�[�X��Ԃ�
      public
      def self.list
        module_eval %-
          @@list
        -
      end
      
      # �������`����
      public
      def self.attribute( name, default=nil )
        if default.nil?
          module_eval %-
            @@attributes << [:#{name}, nil]
            @@default_value[:#{name}] = nil
          -
        else
         module_eval %-
            @@attributes << [:#{name}, '#{default}']
            @@default_value[:#{name}] = '#{default}'
          -
        end
        attr_accessor name
      end
      
      # �K�{�������`����
      public
      def self.required_attribute( *args )
        module_eval %-
          @@required_attributes << :#{args.first}
        -
        attribute( *args )
      end
      
      # �V�������\�[�X�I�u�W�F�N�g��Ԃ�
      public
      def initialize # :yield: self
        set_default_values
        register
        yield self if block_given?
      end

      # ���ׂĂ̑����Ƀf�t�H���g�l���Z�b�g����B
      # �Z�b�g�̓A�N�Z�b�T���\�b�h��ʂ��čs���邽�߁A�A�N�Z�b�T�ɐݒ肳�ꂽ
      # ���ʂȏ��������킹�Ď��s�����B�܂��A���ꂼ��̃C���X�^���X�����Ƃ���
      # �Ǝ��̋� Array �����悤�ɁA�f�t�H���g�l�̃R�s�[���g���B     
      private
      def set_default_values
        self.class.attribute_defaults.each do |attribute, default|
          self.send "#{attribute}=", copy_of(default)
        end
      end
      
      private
      def register
        self.class.list << self
      end
      
      # ���l�ȊO�̓I�u�W�F�N�g�� dup ����
      private
      def copy_of(obj)
        case obj
        when Numeric, Symbol, true, false, nil then obj
        else obj.dup
        end
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: