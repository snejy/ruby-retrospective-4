class NumberSet
  include Enumerable

  def initialize(container = [])
    @container = container
  end

  def <<(number)
   @container << number unless @container.include? number
  end

  def size
    @container.size
  end

  def empty?
    @container.empty?
  end

  def [](condition)
    NumberSet.new @container.select { |number| condition.satisfied_by? number }
  end

  def each(&block)
    @container.each(&block)
  end
end

class Filter
  def initialize(&condition)
    @condition = condition
  end

  def satisfied_by?(number)
    @condition.call number
  end

  def &(other)
    Filter.new { |number| satisfied_by? number and other.satisfied_by? number }
  end

  def |(other)
    Filter.new { |number| satisfied_by? number or other.satisfied_by? number }
  end
end

class TypeFilter < Filter
  def initialize(condition)
    @condition = condition
  end

  def satisfied_by?(number)
    case @condition
    when :integer then number.class == Fixnum or number.class == Bignum
    when :real then number.class == Float or number.class == Rational
    else number.class == Complex
    end
  end
end

class SignFilter < Filter
  def initialize(condition)
    @condition = condition
  end

  def satisfied_by?(number)
    case @condition
    when :positive then number > 0
    when :non_positive then number <= 0
    when :negative then number < 0
    else number >= 0
    end
  end
end