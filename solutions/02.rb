class NumberSet
  include Enumerable

  def initialize(numbers = [])
    @numbers = numbers
  end

  def <<(number)
   @numbers << number unless @numbers.include? number
  end

  def size
    @numbers.size
  end

  def empty?
    @numbers.empty?
  end

  def [](condition)
    NumberSet.new @numbers.select { |number| condition.satisfied_by? number }
  end

  def each(&block)
    @numbers.each &block
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
    when :integer then number.is_a? Integer
    when :real    then number.is_a? Float or number.is_a? Rational
    else number.is_a? Complex
    end
  end
end

class SignFilter < Filter
  def initialize(condition)
    @condition = condition
  end

  def satisfied_by?(number)
    case @condition
    when :positive     then number > 0
    when :non_positive then number <= 0
    when :negative     then number < 0
    else number >= 0
    end
  end
end