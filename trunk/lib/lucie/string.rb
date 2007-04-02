#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


# ɸ��� String ���饹�˥���ǥ�ȷϤΥ᥽�åɤ��ɲ�
class String
  def indent n
    return map do | each |
      ' ' * n + each
    end.join
  end


  # ����ǥ�Ȥ��ݤ��Ĥĺ��󤻤���
  def unindent_auto
    return unindent( minimum_indent )
  end


  # �Ǿ��Υ���ǥ�������֤������֥��ȥåפ� 8 �ȷ׻����롣
  def minimum_indent
    indents = map do | each |
      each.rstrip.untabify.slice( /\A */ ).length
    end
    return ( ( indents - [ 0 ] ).min || 0 )
  end


  # ʸ����� n �֤󥢥󥤥�ǥ�Ȥ���
  def unindent n, tabstopNum = 8
    indent_re = /^ {0,#{n}}/
    return map do | each |
      each.untabify( tabstopNum ).sub( indent_re, '' ).tabify tabstopNum
    end.join( '' )
  end


  # ���֤򥹥ڡ������Ѵ�����
  #--
  # NOTE: don't work with UTF-8
  #++
  def untabify tabstopNum = 8
    return gsub( /(.*?)\t/n ) do
      $1 + ' ' * ( tabstopNum - ( $1.length % tabstopNum ) )
    end
  end


  # ��Ƭ�Υ��ڡ����򥿥֤ȥ��ڡ������Ѵ�����
  #--
  # NOTE: don't work with UTF-8
  #++
  def tabify tabstopNum = 8
    return gsub( /^[ \t]+/ ) do | each |
      ntabs, nspaces = each.untabify( tabstopNum ).length.divmod( tabstopNum )
      "\t" * ntabs + ' ' * nspaces
    end
  end


  # 'pascal_style' => 'PascalStyle' �Τ褦���Ѵ�
  def to_pascal_style
    if self.include?( '_' )
      return self.split( '_' ).collect do | each |
        each.capitalize
      end.join
    else
      return self.capitalize
    end
  end


  # Ĺ����ƥ��� RFC822 �˹礦�褦�˥ե����ޥåȤ��롣
  # Debconf �Υƥ�ץ졼�Ȥ� extended description ���Ѥ��롣
  def to_rfc822
    return unindent_auto.map do | each |
      case each
      when /\A\s*\Z/
        " .\n"
      else
        " #{each}"
      end
    end.join( "" )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
