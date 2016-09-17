require_relative '../frontend/main.rb'
require_relative './spec_helper.rb'
require 'rspec'  
require 'rack/test'

set :environment, :test

describe 'Reactive web service' do  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  it "should display JSON dump of lot data" do
    get '/api/v1/web/stats/fl/north/lot-a'
    expect(last_response).to be_ok
  end
  it "should get the current lot usage" do
    get '/api/v1/web/usage/fl/north/lot-a'
    expect(last_response).to be_ok
  end
end