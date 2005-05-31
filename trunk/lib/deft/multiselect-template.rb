#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/template'
require 'deft/abstract-template'
require 'time-stamp'

module Deft 
  # multiselect �����פ� Template �򤢤�魯���饹
  class MultiselectTemplate < AbstractTemplate
    # MultiselectTemplate �򤢤�魯 String ���֥������Ȥ��֤�
    public
    def to_s
      return template_string( 'multiselect', 'default', 'choices' )
    end
    
    # �ǥХå���
    public
    def inspect
      return "#<Deft::MultiselectTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
