#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/template'
require 'deft/abstract-template'
require 'time-stamp'

update(%q$LastChangedDate$)

module Deft 
  # multiselect �^�C�v�� Template ������킷�N���X
  class MultiselectTemplate < AbstractTemplate
    # MultiselectTemplate ������킷 String �I�u�W�F�N�g��Ԃ�
    public
    def to_s
      return template_string( 'multiselect', 'default', 'choices' )
    end
    
    # �e���v���[�g�̌^��Ԃ�
    public
    def template_type
      return 'multiselect'
    end    
    
    # �f�o�b�O�p
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
