#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lmp/template'

module LMP
  # LMP のスペックを管理するクラス
  class Specification
    # アトリビュート名のリスト: [:name, :version, ...]
    @@required_attributes = []
    
    # _すべての_ アトリビュート名 とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
    @@attributes = []
    
    # ------------------------- Convenience class methods.
    
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
    
    # Same as :attribute, but ensures that values assigned to the
    # attribute are array values by applying :to_a to the value.
    def self.array_attribute(name)
      @@attributes << [name, []]
      module_eval %{
        def #{name}
	      @#{name} ||= []
	    end
        def #{name}=(value)
	      @#{name} = value.to_a
	    end
      }
    end
    
    # Sometimes we don't want the world to use a setter method for a particular attribute.
    # +read_only+ makes it private so we can still use it internally.
    def self.read_only(*names)
      names.each do |name|
        private "#{name}="
      end
    end
    
    # ------------------------- REQUIRED LMP attributes.
    
    required_attribute :name
    required_attribute :version
    required_attribute :section, 'misc'
    required_attribute :maintainer
    required_attribute :architecture, 'all'
#    required_attribute :depends  # TODO: implement this.
    required_attribute :short_description
    required_attribute :extended_description
    required_attribute :changelog
    required_attribute :priority, 'optional'
    required_attribute :readme
    required_attribute :control
    required_attribute :postinst
    required_attribute :rules
    required_attribute :deft
    required_attribute :templates 
    required_attribute :package, Template.package
    required_attribute :config
    required_attribute :copyright, 'Copyright: GPL2'
    required_attribute :files, ['debian/README.Debian', 
                                'debian/changelog', 
                                'debian/config', 
                                'debian/control', 
                                'debian/copyright',
                                'debian/postinst',
                                'debian/rules',
                                'debian/templates',
                                'package']
    read_only :config
    read_only :section
    read_only :architecture
    read_only :priority                            
    read_only :templates 
    read_only :control
    read_only :rules                               
    read_only :package
    read_only :files
    read_only :readme
    read_only :changelog
        
    # ------------------------- OPTIONAL LMP attributes.
    
    # ------------------------- Constructors.

    public
    def initialize
      @@attributes.each do |name, default|
        self.send "#{name}=", copy_of( default )
      end
      yield self if block_given?
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
    
    # ------------------------- Template methods.
    
    public
    def config
      Template.config( self )
    end
    
    public
    def control
      Template.control( self )
    end
    
    public
    def rules
      Template.rules( @name )
    end
    
    public
    def readme
      Template.readme( @name )
    end
    
    public
    def changelog
      Template.changelog( self )
    end
    
    public
    def templates
      Deft::Template.templates.map do |each|
        each.to_s 
      end.join("\n\n")
    end
    
    # ------------------------- Debug methods.

    public
    def inspect
      return to_s
    end
    
    public
    def to_s
      return "#<LMP::Specification name=#{@name} version=#{@version}>"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
