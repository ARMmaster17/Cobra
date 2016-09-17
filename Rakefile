require_relative 'frontend/main'
require 'sinatra/activerecord/rake'
require 'redis'
require 'json'
require 'selenium-webdriver'

task :test do
  ruby "testing/testall.rb"
end

task :seed do
    puts "WARNING: THIS WILL CLEAR THE DATABASE AND ALL OF ITS DATA!"
    Lot.destroy_all
    Zone.destroy_all
    Site.all.destroy_all
    site1 = Site.create do |s|
        s.full_name = 'Daytona Beach, FL'
        s.short_name = 'fl'
    end
    zone1 = site1.zones.create do |z|
        z.full_name = 'North Campus'
        z.short_name = 'north'
    end
    lot1 = zone1.lots.create do |l|
        l.full_name = 'Lot A'
        l.short_name = 'lot-a'
        l.total_spaces = 50
        l.is_restricted_access = true
        l.is_trackable = true
        l.used_spaces = 27
    end
    lot2 = zone1.lots.create do |l|
        l.full_name = 'Lot B'
        l.short_name = 'lot-b'
        l.total_spaces = 50
        l.is_restricted_access = true
        l.is_trackable = true
        l.used_spaces = 14
    end
    zone2 = site1.zones.create do |z|
        z.full_name = 'South Campus'
        z.short_name = 'south'
    end
    lot3 = zone2.lots.create do |l|
        l.full_name = 'Deck 1'
        l.short_name = 'deck-1'
        l.total_spaces = 400
        l.is_restricted_access = true
        l.is_trackable = true
        l.used_spaces = 312
    end
    lot4 = zone2.lots.create do |l|
        l.full_name = 'Guest Lot'
        l.short_name = 'guest-lot'
        l.total_spaces = 20
        l.is_restricted_access = false
        l.is_trackable = true
        l.used_spaces = 4
    end
    redis = Redis.new(url: ENV["REDIS_URL"])
    
    key1 = Hash.new
    key1['identifier'] = "1111AAAA"
    key1['secret'] = "123456789ABCDEFGHI"
    key1['permissions'] = 'rw'
    redis.set(key1['identifier'], key1.to_json)
    
    key2 = Hash.new
    key2['identifier'] = "AAAA1111"
    key2['secret'] = "ABCDEFGHI123456789"
    key2['permissions'] = 'r'
    redis.set(key2['identifier'], key2.to_json)
end

task :seleniumtest do
    caps = Selenium::WebDriver::Remote::Capabilities.android()
    caps['appiumVersion'] = '1.5.3'
    caps['recordVideo'] = false
    caps['deviceName'] = 'Android Emulator'
    caps['deviceType'] = 'phone'
    caps['deviceOrientation'] = 'portrait'
    caps['browserName'] = 'Browser'
    caps['platformVersion'] = '5.1'
    caps['platformName'] = 'Android'
    caps['build'] = ENV['TRAVIS_BUILD_NUMBER']
    caps['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
    driver = Selenium::WebDriver.for(:remote, {
        url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub",
        desired_capabilities: caps
    })
    driver.get 'http://localhost:8080/'
    driver.get 'http://localhost:8080/data'
    driver.get 'http://localhost:8080/data/fl'
    driver.get 'http://localhost:8080/data/fl/north'
    driver.get 'http://localhost:8080/data/fl/north/lot-a'
    driver.close
end