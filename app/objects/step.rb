class Step
  attr_reader :requirements
  def initialize(tree)
    @requirements = init_requirements(tree["reqs"])
    @children = []
    if tree["answer"]
      @answers = tree["answer"]
    elsif tree["children"]
      @children = init_children(tree["children"])
    end
  end

  def accept(visitor)
    @requirements.each do |requirement|
      requirement[:study].accept(visitor, requirement[:value])
    end
    if @answers
      @answers.each do |answer|
        visitor.add_ddx(answer, true)
      end
      return
    end
    next_step(visitor)
  end

  def accept_default(visitor)
    @requirements.each do |requirement|
      requirement[:study].accept(visitor, "normal")
    end
    if @answers
      @answers.each do |answer|
        visitor.add_ddx(answer, false)
      end
      return
    end
    next_default(visitor)
  end

  def next_default(visitor)
    @children.each do |child|
      child.accept_default(visitor)
    end
  end

  def make_necessary(visitor)
    @requirements.each do |requirement|
      visitor.add_necessary_study(requirement[:study])
    end
    @children.each do |child|
      child.requirements.each do |requirement|
        visitor.add_necessary_study(requirement[:study])
      end
    end
  end

  def next_step(visitor)
    right = @children.sample
    right.accept(visitor)
    right.make_necessary(visitor)

    # @children.each do |child|
    #   child.accept(visitor, false)
    # end
    # if y_n
    #   right = @children.sample
    #   right.accept(visitor, true)
    #   right.make_necessary(visitor)
    # end
    # if y_n
    #   right = @children.sample
    #   wrongs = @children
    #   wrongs.each do |wrong|
    #     wrong.accept(visitor, false)
    #   end
    #   right.accept(visitor, true)
    #   right.make_necessary(visitor)
    # else
    #   @children.each do |child|
    #     child.accept(visitor, false)
    #   end
    # end
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
      list.push({ study: StudyFinder.create_study(name), value: reading})
    end
    list
  end
end
