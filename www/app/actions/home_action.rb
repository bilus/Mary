class HomeAction < Cramp::Action
  def start
    render "Hello, world"
    finish
  end
end
