# base class for all types to inherit base features from
class TypeBase
  require_relative '../hash_dumper'

  attr_reader :name

  def initialize(name = nil, options = {})
    @name = name
    @options = options
  end

  def to_s
    type = self.class.name.split(':')[-1]
    type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
    type.capitalize!
    "#{type} '#{@name}'"
  end

  def inspect
    defined?(PowerAssert) ? @inspection : to_s
  end

  def to_ary
    to_s.split(' ')
  end
end
