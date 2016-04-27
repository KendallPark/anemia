class Step
  def initialize(tree)
    @requirements = init_requirements(tree["reqs"])
    if tree["answer"]
      @answers = tree["answer"]
    elsif tree["children"]
      @children = init_children(tree["children"])
    end
  end

  def accept(visitor, y_n)
    @requirements.each do |requirement|
      requirement[:study].accept(visitor, requirement[:value], y_n)
    end
    if @answers
      @answers.each do |answer|
        visitor.add_ddx(answer, y_n)
      end
      return
    end
    next_step(visitor, y_n)
  end

  def next_step(visitor, y_n)
    if y_n
      right = @children.sample
      wrongs = @children - [right]
      wrongs.each do |wrong|
        wrong.accept(visitor, false)
      end
      right.accept(visitor, true)
    else
      @children.each do |child|
        child.accept(visitor, false)
      end
    end
  end

private

  def init_children(children)
    list = []
    children.each do |child|
      list.push Step.new(child)
    end
    list
  end

  def init_requirements(reqs)
    list = []
    reqs.each do |req|
      name, reading = req.first
      if ["abnormal", "normal"].include? reading
        list.push({ study: Finding.new(name), value: reading})
      else
        list.push({ study: Lab.new(name), value: reading })
      end
    end
    list
  end
end
