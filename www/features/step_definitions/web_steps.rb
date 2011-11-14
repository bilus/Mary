When /^I visit the home page$/ do
  visit "/"
end

Then /^it should say "([^"]*)"$/ do |text|
  page.should have_content(text)
end
