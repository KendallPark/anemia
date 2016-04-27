class Visitor
  attr_reader :groups, :ddx
  def initialize
    @groups = {}
    @ddx = []
  end
  def add_finding(group, name, desc, y_n)
    group = name if group == "self"
    @groups[group] = {} unless @groups[group]
    return if @groups[group][name] && @groups[group][name][:necessary]
    @groups[group][name] = { text: desc }
    @groups[group][:necessary] |= y_n
    @groups[group][name][:necessary] |= y_n
  end
  def add_lab(group, name, desc, y_n)
    group = name if group == "self"
    @groups[group] = {necessary: false} unless @groups[group]
    return if @groups[group][name] && @groups[group][name][:necessary]
    @groups[group][name] = { text: desc }
    @groups[group][:necessary] |= y_n
    @groups[group][name][:necessary] |= y_n
  end
  def add_ddx(name, y_n)
    @ddx.push({name: name, correct: y_n})
  end
  def to_h
    { groups: @groups, ddx: @ddx }
  end
end
