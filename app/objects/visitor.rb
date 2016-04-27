class Visitor
  attr_reader :groups, :ddx
  def initialize
    @groups = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    @ddx = {}
  end
  def add_study(group, name, desc)
    @groups[group][:necessary] = false unless @groups[group].has_key?(:necessary)
    @groups[group][name][:necessary] = false unless @groups[group][name].has_key?(:necessary)
    @groups[group][name] = {text: desc, necessary: false}
    # @groups[group] unless @groups.has_key?(group)
    # return if @groups[group].has_key?(name) && @groups[group][name].has_key?(:necessary)
    # @groups[group][name][:text] = desc
    # @groups[group][name][:necessary] = false unless @groups[group][name].has_key?(:necessary)
    # @groups[group][name][:necessary] |= false
  end
  def add_ddx(name, correct)
    @ddx[name] = correct
  end
  def add_necessary_study(study)
    @groups[study.group][:necessary] = true
    @groups[study.group][study.name][:necessary] = true
  end
  def to_h
    ddx_list = @ddx.keys.map { |key| {name: key, correct: @ddx[key]}}
    { groups: @groups, ddx: ddx_list.sort { |x, y| x[:name] <=> y[:name] } }
  end
end
