#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'time-stamp'

update(%q$LastChangedDate$)

# �W���� String �N���X�ɃC���f���g�n�̃��\�b�h��ǉ�
class String
  public
  def indent( n )
    return map do |each|
      ' ' * n + each
    end
  end
  
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
  
  # 'pascal_style' => 'PascalStyle' �̂悤�ɕϊ�
  public
  def to_pascal_style
    if self.include?('_')
      return self.split('_').collect do |each| 
        each.capitalize 
      end.join
    else
      return self.capitalize
    end
  end  
  
  # �������e������ RFC822 �ɍ����悤�Ƀt�H�[�}�b�g����B
  # Debconf �̃e���v���[�g�� extended description �ɗp����B    
  public
  def to_rfc822
    return unindent_auto.split("\n").map do |each|
      case each
      when /\A\s*\Z/
          ' .'
      else
          " #{each}"
      end
    end.join("\n")
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: