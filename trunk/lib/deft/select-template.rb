#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'time-stamp'

module Deft  
  # select �����פ� Template �򤢤�魯���饹
  class SelectTemplate < AbstractTemplate
    # SelectTemplate �򤢤�魯 String ���֥������Ȥ��֤�
    public
    def to_s
      return template_string( 'select', 'default', 'choices' )
    end

    # �ǥХå���
    public
    def inspect
      return "#<Deft::SelectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
