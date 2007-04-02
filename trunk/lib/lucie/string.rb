#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


# 標準の String クラスにインデント系のメソッドを追加
class String
  def indent n
    return map do | each |
      ' ' * n + each
    end.join
  end


  # インデントを保ちつつ左寄せする
  def unindent_auto
    return unindent( minimum_indent )
  end


  # 最小のインデント幅を返す。タブストップは 8 と計算する。
  def minimum_indent
    indents = map do | each |
      each.rstrip.untabify.slice( /\A */ ).length
    end
    return ( ( indents - [ 0 ] ).min || 0 )
  end


  # 文字列を n ぶんアンインデントする
  def unindent n, tabstopNum = 8
    indent_re = /^ {0,#{n}}/
    return map do | each |
      each.untabify( tabstopNum ).sub( indent_re, '' ).tabify tabstopNum
    end.join( '' )
  end


  # タブをスペースに変換する
  #--
  # NOTE: don't work with UTF-8
  #++
  def untabify tabstopNum = 8
    return gsub( /(.*?)\t/n ) do
      $1 + ' ' * ( tabstopNum - ( $1.length % tabstopNum ) )
    end
  end


  # 行頭のスペースをタブとスペースに変換する
  #--
  # NOTE: don't work with UTF-8
  #++
  def tabify tabstopNum = 8
    return gsub( /^[ \t]+/ ) do | each |
      ntabs, nspaces = each.untabify( tabstopNum ).length.divmod( tabstopNum )
      "\t" * ntabs + ' ' * nspaces
    end
  end


  # 'pascal_style' => 'PascalStyle' のように変換
  def to_pascal_style
    if self.include?( '_' )
      return self.split( '_' ).collect do | each |
        each.capitalize
      end.join
    else
      return self.capitalize
    end
  end


  # 長いリテラルを RFC822 に合うようにフォーマットする。
  # Debconf のテンプレートの extended description に用いる。
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
