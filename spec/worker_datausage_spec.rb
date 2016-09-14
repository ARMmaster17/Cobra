require_relative '../backend/lib/data_usage.rb'
require_relative '../spec_helper.rb'
require 'rspec'

set :environment, :test

describe 'lot usage service' do  
  it "should update lot usage" do
    DataUsage.go('fl/north/lot-a')
  end
  it "should update zone usage" do
    DataUsage.go('fl/north')
  end
  it "should update site usage" do
    DataUsage.go('fl')
  end
end