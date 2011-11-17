When /^(?!the)([^ ]+) creates a new project "([^"]*)"$/ do |investor_name, project_name|
  Capybara.session_name = investor_name
  step "the investor creates a new project \"#{project_name}\""
end

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

When /^(?!the)([^ ]+) generates a profitability report$/ do |investor_name|
  Capybara.session_name = investor_name
  step "the investor generates a profitability report"
end

When /^([^ ]+) refreshes his report$/ do |investor_name|
  Capybara.session_name = investor_name
  visit(current_url)
end



Then /^the report should include "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^it should say "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^([^']+)'s report should include "([^"]*)"$/ do |investor_name, text|
  Capybara.session_name = investor_name
  step "the report should include \"#{text}\""
end
