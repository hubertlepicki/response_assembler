require File.join(File.dirname(__FILE__), "..", "lib", "response_assembler", "middleware")
Bundler.require
require 'testapp'

describe "ResponseAssembler::Middleware" do
  include Rack::Test::Methods

  def app
    ResponseAssembler::Middleware.new(TestApp.new, "Oh, no!")
  end

  it "pass response returned by application when no recognized tags were found" do
    get '/'
    last_response.should be_ok
    last_response.body.should eql('Hello World')
  end
 
  it "renders response1 on /response1" do
    get "/response1"
    last_response.should be_ok
    last_response.body.should == "GET_response1"
  end

  it "renders response2 on /response2" do
    get "/response2"
    last_response.should be_ok
    last_response.body.should == "GET_response2"
  end

  it "should embed paths wrapped in <get> tags" do
    get "/embed_two"
    last_response.should be_ok
    last_response.body.should == "[GET_response1] [GET_response2]"
  end

  it "should recognize ajax an non-ajax calls" do
    get "/get_ajax_and_not_ajax"
    last_response.should be_ok
    last_response.body.should == "[Ajax!] [Non-Ajax!]"
  end
end
