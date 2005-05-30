#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'time-stamp'

update(%q$LastChangedDate$)

module Deft  
  # boolean ?^?C?v? Template ??çí??N???X
  class BooleanTemplate < AbstractTemplate   
    # BooleanTemplate ??çí? String ?I?u?W?F?N?g??��
    public
    def to_s
      return template_string( 'boolean', 'default' )
    end
    
    # �ƥ�ץ졼�Ȥη���ʸ������֤�
    public
    def template_type
      return 'boolean'
    end
    
    # boolean template �Ǥ� choices °�������ѤǤ��ʤ�
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # �ǥХå���
    public
    def inspect
      return "#<Deft::BooleanTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
