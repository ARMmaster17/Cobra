require_relative '../frontend/main.rb'
require_relative '../spec_helper.rb'
require 'rspec'  
require 'rack/test'

set :environment, :test

describe 'API Service' do  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should increment the number of used spots in Lot A" do
    get '/api/v1/flow/inbound/raw/fl/north/lot-a?id=1111AAAA&secret=123456789ABCDEFGHI'
    expect(last_response).to be_ok
  end
  it "should decrement the number of used spots in Lot A" do
    get '/api/v1/flow/outbound/raw/fl/north/lot-a?id=1111AAAA&secret=123456789ABCDEFGHI'
    expect(last_response).to be_ok
  end
end