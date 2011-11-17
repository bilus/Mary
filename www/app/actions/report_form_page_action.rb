class ReportFormPageAction < Cramp::Action
  def start
    render Tilt::HamlTemplate.new('app/views/report_form.html.haml').render(self)
    finish
  end
end