require 'bigdecimal'

class Lab
  attr_reader :name, :min, :norm_min, :norm_max, :max, :unit, :group

  def initialize(lab_name)
    yaml = YAML::load_file(Rails.root.join("config", "labs.yml"))
    lab = yaml["labs"][lab_name]
    @name = lab_name
    @min = lab.fetch("min")
    @norm_min = lab.fetch("norm_min")
    @norm_max = lab.fetch("norm_max")
    @max = lab.fetch("max")
    @unit = lab.fetch("unit")
    @group = lab.fetch("group")
  end

  def desc(reading)
    "#{@name}: #{rand_reading(reading)} #{unit} (#{@norm_min}-#{@norm_max})"
  end

  def rand_reading(reading)
    case reading
    when "low"
      return rand_between(min, norm_min).to_f
    when "norm"
      return rand_between(norm_min, norm_max).to_f
    when "high"
      return rand_between(norm_max, max).to_f
    end
  end

  def rand_between(a, b)
    puts a, b
    BigDecimal.new((rand * (a - b) + b), 3).to_f
  end

  def accept(visitor, reading, y_n)
    reading = reading.sample if reading.kind_of? Array
    reading = "norm" unless y_n
    visitor.add_lab(@group, @name, desc(reading), y_n)
  end
end
