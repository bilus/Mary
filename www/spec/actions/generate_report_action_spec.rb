# require 'spec_helper'
require File.join(File.dirname(__FILE__), "../../application")
require File.join(File.dirname(__FILE__), "../../lib/project")
require 'rspec/cramp'

describe "Report generation", :cramp => true do
  def app
    Mary::Application.routes
  end
  context "routes" do
    it "should respond to POST /report" do
      post("/report").should respond_with :status => :ok
    end
  end
  context "api" do
    it "should respond with status info" do
      post("/report").should respond_with :body => /.*"status":"ok".*/
    end
  end
  context "project creation" do
    it "should initialize project" do
      Project.should_receive(:initialize!).with("EW Lubrza")
      post("/report", :params => {:project_name => "EW Lubrza"})
    end
    it "should initialize project with a different project name" do
      Project.should_receive(:initialize!).with("EW Wilamowa")
      post("/report", :params => {:project_name => "EW Wilamowa"})
    end
    it "should respond with the generated access token" do
      Project.should_receive(:initialize!).and_return("1234")
      post("/report").should respond_with :body => /.*"access_token":"1234".*/
    end
  end
end
