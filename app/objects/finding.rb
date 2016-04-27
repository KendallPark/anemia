class Finding
  def initialize(finding_name)
    yaml = YAML::load_file(Rails.root.join("config", "labs.yml"))
    findings = yaml["findings"][finding_name]
    @name = finding_name
    @abnormal = findings.fetch("abnormal")
    @normal = findings.fetch("normal")
    @group = findings.fetch("group")
  end

  def desc(norm_or_ab="normal")
    case norm_or_ab
    when "normal"
      "#{@name}: #{@normal}"
    when "abnormal"
      "#{@name}: #{@abnormal}"
    end
  end

  def accept(visitor, norm_or_ab, y_n)
    norm_or_ab = "normal" unless y_n
    visitor.add_finding @group, @name, desc(norm_or_ab), y_n
  end

end
