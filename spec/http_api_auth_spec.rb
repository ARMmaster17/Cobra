require_relative '../frontend/main.rb'
require_relative './spec_helper.rb'
require 'rspec'  
require 'rack/test'

set :environment, :test

describe 'API Auth Service' do  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should allow a RW key to perform the transaction" do
    get '/api/v1/flow/inbound/raw/fl/north/lot-a?id=1111AAAA&secret=123456789ABCDEFGHI'
    expect(last_response).to be_ok
  end
  it "should not allow a R key to perform the transaction" do
    get '/api/v1/flow/inbound/raw/fl/north/lot-a?id=AAAA1111&secret=ABCDEFGHI123456789'
    expect(last_response).to_not be_ok
  end
  it "should allow a RW key to perform the transaction" do
    get '/api/v1/flow/outbound/raw/fl/north/lot-a?id=1111AAAA&secret=123456789ABCDEFGHI'
    expect(last_response).to be_ok
  end
  it "should not allow a R key to perform the transaction" do
    get '/api/v1/flow/outbound/raw/fl/north/lot-a?id=AAAA1111&secret=ABCDEFGHI123456789'
    expect(last_response).to_not be_ok
  end
end