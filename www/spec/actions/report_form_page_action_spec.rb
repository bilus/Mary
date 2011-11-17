# require 'spec_helper'
require File.join(File.dirname(__FILE__), "../../application")
require 'rspec/cramp'

describe "Report form page", :cramp => true do
  def app
    Mary::Application.routes
  end
  context "routes" do
    it "should be accessible using GET" do
      get("/report_form.html").should respond_with :status => :ok
    end
  end
end
