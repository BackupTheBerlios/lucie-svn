#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'time-stamp'

update(%q$Id$)

module Deft  
  # boolean ���Υƥ�ץ졼�Ȥ�ɽ�����饹
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate �� RFC822 �ˤ��ɽ�����֤�
    public
    def to_s
      super
      return template_string( 'boolean', 'default' )
    end
    
    # boolean template �Ǥ� choices °�������ѤǤ��ʤ�
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end

    # 'true' �� 'false' �ʳ��� default ��Ϥͤ�
    public
    def default=( defaultString ) # :nodoc:
      unless (defaultString == 'true') or (defaultString == 'false')
        raise Deft::Exception::InvalidAttributeException, "default must be 'true' or 'false'"
      end
      super
    end
    
    # �ǥХå���
    public
    def inspect # :nodoc:
      return "#<Deft::BooleanTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
