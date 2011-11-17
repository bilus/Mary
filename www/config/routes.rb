# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  add('/').to(HomeAction)
  add('/report_form.html').to(ReportFormPageAction)
  add('/report').post.to(GenerateReportAction)
  add('/report.html').get.to(ReportPageAction)
end

