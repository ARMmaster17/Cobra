require_relative '../backend/lib/api_flow_raw.rb'
require_relative './spec_helper.rb'
require 'rspec'
require 'json'

set :environment, :test

describe 'API flow backend' do  
  it "should increment lot usage counter" do
    payload = Hash.new
    payload['site'] = 'fl'
    payload['zone'] = 'north'
    payload['lot'] = 'lot-a'
    payload['direction'] = 'in'
    ApiFlowRaw.go(payload.to_json)
  end
  it "should decrement lot usage counter" do
    payload = Hash.new
    payload['site'] = 'fl'
    payload['zone'] = 'north'
    payload['lot'] = 'lot-a'
    payload['direction'] = 'out'
    ApiFlowRaw.go(payload.to_json)
  end
end