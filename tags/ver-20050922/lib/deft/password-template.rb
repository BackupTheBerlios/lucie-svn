#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/abstract-template'
require 'deft/template'
require 'deft/time-stamp'

module Deft
  update(%q$Id$)

  # password ���� Template �򤢤�魯���饹
  class PasswordTemplate < AbstractTemplate   
    # PasswordTemplate �� RFC822 �ˤ��ɽ�����֤�
    public
    def to_s
      super
      return template_string( 'password', 'default' )
    end
    
    public
    def choices=( choicesString ) # :nodoc:
      raise Deft::Exception::InvalidAttributeException
    end
    
    # �ǥХå���
    public
    def inspect # :nodoc:
      return "#<Deft::PasswordTemplate: @name=\"#{@name}\">"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: