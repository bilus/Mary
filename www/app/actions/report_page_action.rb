require File.join(File.dirname(__FILE__), "../../lib/project")

class ReportPageAction < Cramp::Action
  def start
    render Project.name(params[:id])
    finish
  end
end