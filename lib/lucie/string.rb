#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'

Lucie::update(%q$LastChangedDate$)

# �W���� String �N���X�ɃC���f���g�n�̃��\�b�h��ǉ�
class String
  # �C���f���g��ۂ����񂹂���
  public
  def unindent_auto
    return unindent( minimum_indent )
  end
  
  # �ŏ��̃C���f���g����Ԃ��B�^�u�X�g�b�v�� 8 �ƌv�Z����B
  public
  def minimum_indent
    indents = map do |each|
      each.rstrip.untabify.slice(/\A */).length
    end
    return ((indents - [0]).min || 0)
  end
  
  # ������� n �Ԃ�A���C���f���g����
  public
  def unindent( n, tabstopNum = 8 )
    indent_re = /^ {0,#{n}}/
    return map do |each|
      if tabstopNum
        each.untabify( tabstopNum ).sub( indent_re, '' ).tabify tabstopNum
      else
        each.sub indent_re, ''
      end
    end.join('')
  end   
  
  # �^�u���X�y�[�X�ɕϊ�����
  #--
  # NOTE: don't work with UTF-8
  #++
  public
  def untabify( tabstopNum = 8 )
    return gsub(/(.*?)\t/n) do $1 + ' ' * (tabstopNum - ($1.length % tabstopNum)) end
  end
  
  # �s���̃X�y�[�X���^�u�ƃX�y�[�X�ɕϊ�����
  #--
  # NOTE: don't work with UTF-8
  #++
  public
  def tabify( tabstopNum = 8)
    return gsub(/^[ \t]+/) do |each|
      ntabs, nspaces = each.untabify( tabstopNum ).length.divmod( tabstopNum )
      "\t" * ntabs + ' ' * nspaces
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
