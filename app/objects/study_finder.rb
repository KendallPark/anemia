class StudyFinder
  def self.create_study(study_name)
    studies = YAML::load_file(Rails.root.join("config", "labs.yml"))
    findings = studies["findings"]
    labs = studies["labs"]
    if findings[study_name]
      Finding.new(findings[study_name].merge({"name" => study_name}))
    elsif labs[study_name]
      Lab.new(labs[study_name].merge({"name"=> study_name}))
    else
      nil
    end
  end
end
