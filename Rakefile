require_relative 'frontend/main'
require 'sinatra/activerecord/rake'
require 'redis'
require 'json'
require 'selenium-webdriver'
require 'sauce_whisk'

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
    caps1 = Selenium::WebDriver::Remote::Capabilities.android()
    caps1['appiumVersion'] = '1.5.3'
    caps1['recordVideo'] = false
    caps1['deviceName'] = 'Android Emulator'
    caps1['deviceType'] = 'phone'
    caps1['deviceOrientation'] = 'portrait'
    caps1['browserName'] = 'Browser'
    caps1['platformVersion'] = '5.1'
    caps1['platformName'] = 'Android'
    caps1['build'] = ENV['TRAVIS_BUILD_NUMBER']
    caps1['name'] = ENV['TRAVIS_BUILD_NUMBER'] + ".1"
    caps1['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
    run_selenium_test(caps1)
    caps2 = Selenium::WebDriver::Remote::Capabilities.iphone()
    caps2['appiumVersion'] = '1.5.3'
    caps2['recordVideo'] = false
    caps2['deviceName'] = 'iPhone 6 Simulator'
    caps2['deviceOrientation'] = 'portrait'
    caps2['platformVersion'] = '9.3'
    caps2['platformName'] = 'iOS'
    caps2['browserName'] = 'Safari'
    caps2['build'] = ENV['TRAVIS_BUILD_NUMBER']
    caps2['name'] = ENV['TRAVIS_BUILD_NUMBER'] + ".2"
    caps2['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
    run_selenium_test(caps2)
    caps3 = Selenium::WebDriver::Remote::Capabilities.firefox()
    caps3['platform'] = 'Windows 10'
    caps3['version'] = '48.0'
    caps3['recordVideo'] = false
    caps3['build'] = ENV['TRAVIS_BUILD_NUMBER']
    caps3['name'] = ENV['TRAVIS_BUILD_NUMBER'] + ".3"
    caps3['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
    run_selenium_test(caps3)
end

def run_selenium_test(caps)
    driver = Selenium::WebDriver.for(:remote, {
        url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub",
        desired_capabilities: caps
    })
    driver.get 'http://localhost:8080/'
    driver.get 'http://localhost:8080/data'
    driver.get 'http://localhost:8080/data/fl'
    driver.get 'http://localhost:8080/data/fl/north'
    driver.get 'http://localhost:8080/data/fl/north/lot-a'
    sessionid = driver.session_id
    driver.quit
    SauceWhisk::Jobs.pass_job sessionid
end