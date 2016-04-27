class Finding
  attr_reader :name, :group
  def initialize(params)
    @name = params.fetch("name")
    @abnormal = params.fetch("abnormal")
    @normal = params.fetch("normal")
    @group = params.fetch("group")
    @group = @name if @group == "self"
  end

  def desc(norm_or_ab="normal")
    case norm_or_ab
    when "normal"
      "#{@name}: #{@normal}"
    when "abnormal"
      "#{@name}: #{@abnormal}"
    end
  end

  def accept(visitor, norm_or_ab)
    visitor.add_study @group, @name, desc(norm_or_ab)
  end

end
