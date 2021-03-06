#
# $Id$
#
# Author:: Yasuhito TAKAMIYA, <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision$
# License:: GPL2

require 'depends/dependency'

module Depends
  module Exception
    class InconsistentPackageListException < ::Exception; end
  end

  # パッケージ情報を表すクラス。内部的に使用。
  #--
  # TODO: 各アトリビュートの rdoc を追加
  #++ 
  class Package
    attr_reader :architecture
    attr_reader :conffiles
    attr_reader :conflicts
    attr_reader :depends
    attr_reader :description
    attr_reader :essential
    attr_reader :installed_size
    attr_reader :maintainer
    attr_reader :name
    attr_reader :priority
    attr_reader :provides
    attr_reader :recommends
    attr_reader :replaces
    attr_reader :section
    attr_reader :short_description
    attr_reader :source
    attr_reader :status
    attr_reader :suggests
    attr_reader :version 

    # Returns a new Package object.
    # 
    # _Example_:
    #
    #  spec = <<CONTROL
    #   Package: lv
    #   Priority: optional
    #   Section: text
    #   Installed-Size: 628
    #   Maintainer: GOTO Masanori <gotom@debian.or.jp>
    #   Architecture: i386
    #   Version: 4.49.4-8
    #   Depends: libc6 (>= 2.2.5-13), libncurses5 (>= 5.2.20020112a-1)
    #   Recommends: bzip2
    #   Filename: pool/main/l/lv/lv_4.49.4-8_i386.deb
    #   Size: 414622
    #   MD5sum: 0f6e74e775932f6e5fe5d22292a06090
    #   Description: Powerful Multilingual File Viewer
    #    lv is a powerful file viewer like less.
    #    lv can decode and encode multilingual streams through
    #    many coding systems:
    #    ISO-8859, ISO-2022, EUC, SJIS, Big5, HZ, Unicode.
    #    .
    #    It recognizes multi-bytes patterns as regular
    #    expressions, lv also provides multilingual grep.
    #    In addition, lv can recognize ANSI escape sequences
    #    for text decoration.
    #   Task: japanese
    #  CONTROL
    #
    #  Depends::Package.new(spec)  #=> aNewPackageObj
    #
    def initialize( controlString )
      conffiles = false
      description = false

      @conffiles = []
      @conflicts = nil
      @control = controlString
      @depends  = []
      @description = []
      @provides = []
      @status = nil

      @control.split(/\n/).each { |each|
        if /^([a-zA-Z\-]+):\s+(.*)/=~ each
          field_name, field_value = $1, $2
          conffiles = false unless (field_name == 'Conffiles')
          description = false unless (field_name == 'Description')
          case field_name
          when 'Config-Version' 
            @config_version = field_value
          when 'Enhances'
            @enhances = field_value
          when 'Size'
            @size = field_value
          when 'Filename'
            @filename = field_value
          when 'Bugs'
            @bugs = field_value
          when 'Origin'
            @origin = field_value
          when 'Pre-Depends'
            @pre_depends = field_value
          when 'Architecture'
            @architecture = field_value
          when 'Package'
            @name = field_value
          when 'Status'
            @status = field_value.split(' ')
          when 'Priority'
            @priority = field_value
          when 'Section'
            # NOTE make this an array? split on possible '/' (e.g. non-free)
            @section = field_value
          when 'Installed-Size'
            @installed_size = field_value.to_i
          when 'Maintainer'
            @maintainer = field_value
          when 'Source'
            @source = field_value
          when 'Version'
            @version = field_value
          when 'Provides'
            @provides = field_value.split(/,\s*/)
          when 'Recommends'
            @recommends = field_value
          when 'Suggests'
            @suggests = field_value
          when 'Conflicts'
            @conflicts = field_value
          when 'Essential'
            @essential = field_value
          when 'Replaces'
            @replaces = field_value
          when 'Depends'
            # split up 'foo (>= 42), bar, foo | bar'
            field_value.split(/,\s*/).each{ |dep_raw|
              dep_raw.split(/\s*\|\s*/).each{ |dep|
                @depends << Dependency.new(dep)
              }}
          when 'Description'
            @short_description = field_value
            description = true
          else
            STDERR.puts "Package: unknown field: #{field_name}." if $trace
          end
        else
          @conffiles << each[1..-1] if conffiles
          conffiles = true if (each=='Conffiles:') or conffiles
          @description << each[1..-1] if description
        end
      }
      @description = @description.join("\n")
    end

    public
    def installed?
      return (@status and ( @status[2] == 'installed' ))
    end

    public
    def <=>( other ) #:nodoc:
      @name <=> other.name
    end
  end
end 

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
