#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/time-stamp'

Lucie::update(%q$LastChangedDate$)

# 標準の String クラスにインデント系のメソッドを追加
class String
  public
  def indent( n )
    return map do |each|
      ' ' * n + each
    end
  end
  
  # インデントを保ちつつ左寄せする
  public
  def unindent_auto
    return unindent( minimum_indent )
  end
  
  # 最小のインデント幅を返す。タブストップは 8 と計算する。
  public
  def minimum_indent
    indents = map do |each|
      each.rstrip.untabify.slice(/\A */).length
    end
    return ((indents - [0]).min || 0)
  end
  
  # 文字列を n ぶんアンインデントする
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
  
  # タブをスペースに変換する
  #--
  # NOTE: don't work with UTF-8
  #++
  public
  def untabify( tabstopNum = 8 )
    return gsub(/(.*?)\t/n) do $1 + ' ' * (tabstopNum - ($1.length % tabstopNum)) end
  end
  
  # 行頭のスペースをタブとスペースに変換する
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
  
  # 'pascal_style' => 'PascalStyle' のように変換
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
  
  # 長いリテラルを RFC822 に合うようにフォーマットする。
  # Debconf のテンプレートの extended description に用いる。    
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
