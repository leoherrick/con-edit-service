require File.dirname(__FILE__) + "/../con-edit-service.rb"
require 'rspec'
require 'rack/test'
require 'test/unit'
require 'sinatra'
require 'json'
Test::Unit::TestCase.send :include, Rack::Test::Methods

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

describe "con-edit-service" do

it "should pass when sent state:CA and zip:9000" do
  post 'api/v1/validate', [
    {
      :field_name => "state",
      :field_value => "CA"          
    }, 
    {
      :field_name => "zip",
      :field_value => "90000"
    }
    ].to_json
    last_response.should be_ok
    attributes = JSON.parse(last_response.body)
    attributes["status"].should == "pass"
end

it "should fail when sent state:CA and zip:89999" do
  post 'api/v1/validate', [
    {
      :field_name => "state",
      :field_value => "CA"          
    }, 
    {
      :field_name => "zip",
      :field_value => "89999"
    }
    ].to_json
    last_response.should be_ok
    attributes = JSON.parse(last_response.body)
    attributes["status"].should == "fail"
    attributes["message"].should == "this is not a valid zip code for California"
end


end