When /^I visit the home page$/ do
  visit "/"
end

When /^the investor creates a new project "([^"]*)"$/ do |proj_name|
  visit "/report_form.html"
  find("input#project_name").set(proj_name)
end

When /^the investor generates a profitability report$/ do
  find("#generate").click
end

Then /^the report should include "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^it should say "([^"]*)"$/ do |text|
  page.should have_content(text)
end
