class Project
  def self.initialize!(project_name)
    @name = project_name
    rand.to_s
  end
  def self.name
    @name
  end
end