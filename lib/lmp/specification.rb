#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module LMP
  class Specification
    # アトリビュート名のリスト: [:name, :version, ...]
    @@required_attributes = []
    
    # _すべての_ アトリビュート名 とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
    @@attributes = []
    
    # ------------------------- Convenience class methods.

    public
    def self.attributes_clear
      @@attributes.clear
    end
    
    public
    def self.required_attributes_clear
      @@required_attributes.clear
    end
    
    public
    def self.attributes
      return @@attributes.dup
    end
    
    public
    def self.required_attributes
      return @@required_attributes.dup
    end
    
    public
    def self.required_attribute_names
      return required_attributes
    end
    
    public
    def self.required_attribute( *args )
      @@required_attributes << args.first
      attribute( *args )
    end
    
    public
    def self.attribute_names
      return @@attributes.map do |name, default| name end
    end
    
    public
    def self.attribute( name, default=nil )
      @@attributes << [name, default]      
      attr_accessor( name )
    end
    
    # ------------------------- REQUIRED LMP attributes.
    
    required_attribute :name
    required_attribute :version
    required_attribute :section, 'misc'
    required_attribute :maintainer
    required_attribute :architecture
    required_attribute :depends
    required_attribute :short_description
    required_attribute :extended_description
    required_attribute :changelog
    required_attribute :priority, 'optional'
    required_attribute :readme    
    
    # ------------------------- OPTIONAL LMP attributes.
    
    attribute :copyright
    
    # ------------------------- Constructors.
    public
    def initialize
      @@attributes.each do |name, default|
        self.send "#{name}=", copy_of( default )
      end
    end
    
    # 即値以外は +obj+ を dup して返す
    private
    def copy_of( obj )
      case obj
      when Numeric, Symbol, true, false, nil
        return obj
      else
        return obj.dup
      end
    end
    
    # ------------------------- Export methods.
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
