describe "Page that shows an HTML report", :cramp => true do
  def app
    Mary::Application.routes
  end
  context "routes" do
    it "should be accessible using GET" do
      Project.stub!(:name).and_return("anything")
      get("/report.html").should respond_with :status => :ok
    end
  end
  context "results" do
    it "should respond with body including the project name" do
      Project.should_receive(:name).and_return("EW Lubrza")
      get("/report.html").should respond_with :body => /.*EW Lubrza.*/
    end
    it "should use the access token to get project name" do
      Project.should_receive(:name).with("1234").and_return("EW Lubrza")
      get("/report.html?id=1234").should respond_with :body => /.*EW Lubrza.*/
    end
  end
end
