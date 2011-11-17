require File.join(File.dirname(__FILE__), "../../lib/project")

describe Project do
  context "when it is initialized" do
    it "should return an access token" do
      Project.initialize!("EW Lubrza").should_not be_nil
    end
    it "should return unique access tokens" do
      t1 = Project.initialize!("ABC")
      t2 = Project.initialize!("ABC")
      t1.should_not == t2
    end
    it "should return an access token that's difficult to crack (md5)"
  end
  it "should return its name" do
    Project.initialize!("ABC")
    Project.name.should == "ABC"
  end
end
