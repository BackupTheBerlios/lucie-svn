#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie'

include Lucie

question( 'lucie-vmsetup/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/num-nodes'
  question.first_question = true
end

question( 'lucie-vmsetup/num-nodes' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/use-network'
end

question( 'lucie-vmsetup/use-network' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = { true=>'lucie-vmsetup/ip', false=>'lucie-vmsetup/memory-size' }
end

question( 'lucie-vmsetup/ip' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/memory-size'
end

question( 'lucie-vmsetup/memory-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/harddisk-size'
end

question( 'lucie-vmsetup/harddisk-size' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/vm-type'
end

question( 'lucie-vmsetup/vm-type' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/distro'
end

question( 'lucie-vmsetup/distro' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.next_question = 'lucie-vmsetup/application'
end

question( 'lucie-vmsetup/application' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
