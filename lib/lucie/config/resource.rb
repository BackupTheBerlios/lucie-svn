#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Lucie
  module Config
    class Resource      
      # �A�g���r���[�g���̃��X�g: [:name, :version, ...]
      @@required_attributes = []
      
      # _���ׂĂ�_ �A�g���r���[�g�� �ƃf�t�H���g�l�̃��X�g: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      public
      def self.attribute( name, default=nil )
        @@attributes << [name, default]    
        attr_accessor( name )
      end
      
      public
      def self.required_attribute( *args )
        @@required_attributes << args.first
        attribute( *args )
      end
            
      public
      def initialize
        yield self if block_given?
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: