#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Lucie
  module Config
    class Resource      
      # アトリビュート名のリスト: [:name, :version, ...]
      @@required_attributes = []
      
      # _すべての_ アトリビュート名 とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
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