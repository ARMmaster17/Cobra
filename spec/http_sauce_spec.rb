require_relative './spec_helper.rb'
require 'rspec'  

describe 'Full application stack' do  
  it "should display correctly on target device", :use_sauce => true do
    @driver.get 'http://localhost:8080/'
    @driver.get 'http://localhost:8080/data'
    @driver.get 'http://localhost:8080/data/fl'
    @driver.get 'http://localhost:8080/data/fl/north'
    @driver.get 'http://localhost:8080/data/fl/north/lot-a'
  end
end