# $Id: dependency.rb,v 1.3 2004/06/30 06:46:14 takamiya Exp $
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision: 1.3 $
# License::  GPL2


module Depends
  class Dependency
    
    
    attr_reader :name, :relation, :version
    
    
    public
    def initialize( dependencyString )
      @dependency_description = dependencyString
      case @dependency_description
      when /(.*) \(([<>=]+)\s*(.*)\)/
	@name = $1
	relation = $2
	@version = $3
	@relation = 
	  Proc.new { |other_package|
	  (other_package.name == @name) and relation_proc[relation].call( other_package.version )
	}
      when /^(\S+)$/
	@name = $1
	@version = '*'
	@relation = 
	  Proc.new { |other_package| 
	  other_package.name == @name 
	}
      else
	raise "Dependency: could not parse string #{@dependency_description}."
      end
    end


    public 
    def inspect #:nodoc:
      '<Dependency: ' + @dependency_description + '>'
    end


    public
    def _dump( limit ) #:nodoc:
      @dependency_description
    end


    public 
    def self._load( serializedString ) #:nodoc:
      self.new serializedString
    end


    private
    def relation_proc
      { '>>' => Proc.new { |other_version| other_version >  @version },
	'<<' => Proc.new { |other_version| other_version <  @version },
	'>=' => Proc.new { |other_version| other_version >= @version },
	'<=' => Proc.new { |other_version| other_version <= @version },
	'='  => Proc.new { |other_version| other_version == @version } }
    end

    
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
