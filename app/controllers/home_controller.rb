class HomeController < ApplicationController
  def index
    visitor = Visitor.new
    yaml = YAML::load_file(Rails.root.join("config", "steps.yml"))
    algorithm = Step.new(yaml["steps"][0])
    algorithm.accept_default(visitor)
    algorithm.accept(visitor)
    hash = visitor.to_h
    @groups = hash[:groups]
    @ddx = hash[:ddx]
    @rails_side_json = @groups.keys.map { |key| key.gsub(/( )/, '_').downcase! }
  end
end
