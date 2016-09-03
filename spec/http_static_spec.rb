require_relative '../frontend/main.rb'  
require 'rspec'  
require 'rack/test'

set :environment, :test

describe 'Server Service' do  
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
  it "should increment the number of used spots in Lot A" do
    get '/api/v1/flow/inbound/raw/fl/north/lot-a'
    expect(last_response).to be_ok
  end
  it "should decrement the number of used spots in Lot A" do
    get '/api/v1/flow/outbound/raw/fl/north/lot-a'
    expect(last_response).to be_ok
  end
  it "should report the status of Lot A in JSON form" do
    get '/api/v1/display/usage/fl/north/lot-a'
    expect(last_response).to be_ok
  end
end