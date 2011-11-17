require 'json'
require File.join(File.dirname(__FILE__), "../../lib/project")

class GenerateReportAction < Cramp::Action
  def start
    access_token = Project.initialize!(params[:project_name])
    render ({:status => "ok", :access_token => access_token}).to_json
    finish
  end
end