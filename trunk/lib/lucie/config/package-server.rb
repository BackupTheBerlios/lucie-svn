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
      # �o�^����Ă��� Host �̃��X�g
      @@list = {}
      
      # �A�g���r���[�g���̃��X�g: [:name, :version, ...]
      @@required_attributes = []
      
      # _���ׂĂ�_ �A�g���r���[�g���ƃf�t�H���g�l�̃��X�g: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = []
      
      # �A�g���r���[�g������f�t�H���g�l�ւ̃}�b�s���O
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
          # FIXME: http �����ł悢�H
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