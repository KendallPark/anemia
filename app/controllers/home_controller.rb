class HomeController < ApplicationController
  def index
    visitor = Visitor.new
    yaml = YAML::load_file(Rails.root.join("config", "steps.yml"))
    algorithm = Step.new(yaml["steps"][0])
    algorithm.accept(visitor, true)
    @groups = visitor.groups
    @ddx = visitor.ddx.sort { |x, y| x[:name] <=> y[:name] }
    @rails_side_json = @groups.keys.map { |key| key.gsub(/( )/, '_').downcase! }
  end
end
