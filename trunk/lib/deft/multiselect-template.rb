#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/template'
require 'deft/abstract-template'
require 'time-stamp'

update(%q$Id$)

module Deft 
  # multiselect ���� Template �򤢤�魯���饹
  class MultiselectTemplate < AbstractTemplate
    # MultiselectTemplate �� RFC822 �ˤ��ɽ�����֤�
    public
    def to_s
      raise Exception::RequiredAttributeException if @choices.nil?
      super
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
