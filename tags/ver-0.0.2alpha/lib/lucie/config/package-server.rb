#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/config/resource'

module Lucie
  module Config
    class PackageServer < Resource
      # 登録されている Host のリスト
      @@list = {}
      
      # アトリビュート名のリスト: [:name, :version, ...]
      @@required_attributes = []
      
      # _すべての_ アトリビュート名とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # アトリビュート名からデフォルト値へのマッピング
      @@default_value = {}
      
      required_attribute :name
      required_attribute :alias
      required_attribute :uri
      
      # ------------------------- Special accessor behaviours (overwriting default).
      
      REGEXP_PRINTABLE = /\A[ -~]+\z/

      overwrite_accessor :name= do |_name|
        unless (_name.nil?) || ( /\A[\w\-_]+\z/ =~ _name)
          raise InvalidAttributeException, "Invalid attribute for name: #{_name}"
        end
        @name = _name
      end
      
      overwrite_accessor :alias= do |_alias|
        unless (_alias.nil?) || ( REGEXP_PRINTABLE =~ _alias)
          raise InvalidAttributeException, "Invalid attribute for alias: #{_alias}"
        end
        @alias = _alias
      end

      overwrite_accessor :uri= do |_uri|
        unless (_uri.nil?) || ( /\A(http|ftp)\:\/\/[\w\-_\.:\/]+\Z/ =~ _uri)
          # FIXME: http だけでよい？
          raise InvalidAttributeException, "Invalid attribute for uri: #{_uri}"
        end
        @uri = _uri
      end
    
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: