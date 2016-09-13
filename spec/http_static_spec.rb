require_relative '../frontend/main.rb'  
require 'rspec'  
require 'rack/test'

set :environment, :test

describe 'Standard data view web service' do  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should load the home page" do
    get '/'
    expect(last_response).to be_ok
  end
  it "should load the site listings page" do
    get '/data'
    expect(last_response).to be_ok
  end
  it "should load the zone listings page" do
    get '/data/fl'
    expect(last_response).to be_ok
  end
  it "should load the lot listings page" do
    get '/data/fl/north'
    expect(last_response).to be_ok
  end
end