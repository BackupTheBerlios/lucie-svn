#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'parsedate'

# latest Subversion commit date of core libraries for lucie
$svn_date = nil

# All the definitions of class or module in the Lucie distribution
# should include something like this:
#  update(%q$LastChangedDate$)
# at the top of its {module,class} definition.
# 
# This statement updates svn_date, which is accessible from
# any context, so is usable for printing current version info to
# users.
#
# * _svn_timestamp_ : a String of Subversion date id.
# * _Returns_ : svn_date.
#
# Example:
#
#  Module Lucie
#   class FooBar
#    update(%q$LastChangedDate$)
#       ...
#
#   end
#  end
#
def update( svn_timestamp )
  year, month, day = ParseDate::parsedate(svn_timestamp)[0, 3]
  if (year && month && day)
    svn_date = format('%04d-%02d-%02d', year, month, day)
    if (! $svn_date || $svn_date < svn_date)
      $svn_date = svn_date
    end
  end
  return $svn_date
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
