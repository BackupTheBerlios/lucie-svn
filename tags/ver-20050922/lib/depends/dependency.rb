#
# $Id$
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision$
# License::  GPL2

module Depends
  module Exception
    class UnknownDependencyException < ::Exception; end
  end

  # �ѥå������֤ΰ�¸�ط���ɽ�����饹��libdepends �������Ū�˻��Ѥ�
  # ��롣
  class Dependency
    # �ѥå�����̾
    attr_reader :name
    # ��¸�ط�
    attr_reader :relation
    # �С������
    attr_reader :version

    public
    def initialize( dependencyString )
      @dependency_description = dependencyString
      parse_description
    end

    public 
    def inspect #:nodoc:
      return '<Dependency: ' + @dependency_description + '>'
    end

    public
    def _dump( limit ) #:nodoc:
      return @dependency_description
    end

    public 
    def self._load( serializedString ) #:nodoc:
      return self.new( serializedString )
    end

    private
    def parse_description
      case @dependency_description
      when /(.*) \(([<>=]+)\s*(.*)\)/
	@name = $1
	relation = $2
	@version = $3
	@relation = Proc.new do |other_package|
	  (other_package.name == @name) and relation_proc[relation].call( other_package.version )
        end
      when /^(\S+)$/
	@name = $1
	@version = '*'
	@relation = Proc.new do |other_package| 
	  other_package.name == @name 
        end
      else
	raise Exception::UnknownDependencyException, "Dependency: could not parse string #{@dependency_description}."
      end
    end

    private
    def relation_proc
      { '>>' => Proc.new do |other_version| other_version >  @version end,
	'<<' => Proc.new do |other_version| other_version <  @version end,
	'>=' => Proc.new do |other_version| other_version >= @version end,
	'<=' => Proc.new do |other_version| other_version <= @version end,
	'='  => Proc.new do |other_version| other_version == @version end }
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
