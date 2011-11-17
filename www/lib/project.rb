class Project
  def self.initialize!(project_name)
    @names ||= {}
    token = rand.to_s
    @names[token] = project_name
    token
  end
  def self.name(access_token)
    @names[access_token]
  end
end