# require 'spec_helper'
require File.join(File.dirname(__FILE__), "../../application")
require 'rspec/cramp'

describe "Home page", :cramp => true do
  def app
    Mary::Application.routes
  end
  context "routes" do
    it "should be accessible via /" do
      get("/").should respond_with :status => :ok
    end
  end
  context "content" do
    it "should say Hello, world" do
      get("/").should respond_with :body => "Hello, world"
    end
  end
end
