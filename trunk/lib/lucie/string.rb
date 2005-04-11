#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'

Lucie::update(%q$LastChangedDate$)

# ɸ��� String ���饹�˥���ǥ�ȷϤΥ᥽�åɤ��ɲ�
class String
  public
  def indent( n )
    return map do |each|
      ' ' * n + each
    end
  end
  
  # ����ǥ�Ȥ��ݤ��Ĥĺ��󤻤���
  public
  def unindent_auto
    return unindent( minimum_indent )
  end
  
  # �Ǿ��Υ���ǥ�������֤������֥��ȥåפ� 8 �ȷ׻����롣
  public
  def minimum_indent
    indents = map do |each|
      each.rstrip.untabify.slice(/\A */).length
    end
    return ((indents - [0]).min || 0)
  end
  
  # ʸ����� n �֤󥢥󥤥�ǥ�Ȥ���
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
  
  # ���֤򥹥ڡ������Ѵ�����
  #--
  # NOTE: don't work with UTF-8
  #++
  public
  def untabify( tabstopNum = 8 )
    return gsub(/(.*?)\t/n) do $1 + ' ' * (tabstopNum - ($1.length % tabstopNum)) end
  end
  
  # ��Ƭ�Υ��ڡ����򥿥֤ȥ��ڡ������Ѵ�����
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
  
  # 'pascal_style' => 'PascalStyle' �Τ褦���Ѵ�
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
  
  # Ĺ����ƥ��� RFC822 �˹礦�褦�˥ե����ޥåȤ��롣
  # Debconf �Υƥ�ץ졼�Ȥ� extended description ���Ѥ��롣    
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
