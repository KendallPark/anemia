require 'bigdecimal'

class Lab
  attr_reader :name, :min, :norm_min, :norm_max, :max, :unit, :group

  def initialize(params)
    @name = params.fetch("name")
    @min = params.fetch("min")
    @norm_min = params.fetch("norm_min")
    @norm_max = params.fetch("norm_max")
    @max = params.fetch("max")
    @unit = params.fetch("unit")
    @group = params.fetch("group")
    @group = @name if @group == "self"
  end

  def desc(reading)
    "#{@name}: #{rand_reading(reading)} #{unit} (#{@norm_min}-#{@norm_max})"
  end

  def rand_reading(reading)
    case reading
    when "low"
      return rand_between(min, norm_min).to_f
    when "normal"
      return rand_between(norm_min, norm_max).to_f
    when "high"
      return rand_between(norm_max, max).to_f
    end
  end

  def rand_between(a, b)
    BigDecimal.new((rand * (a - b) + b), 3).to_f
  end

  def accept(visitor, reading)
    reading = reading.sample if reading.kind_of? Array
    visitor.add_study(@group, @name, desc(reading))
  end
end
