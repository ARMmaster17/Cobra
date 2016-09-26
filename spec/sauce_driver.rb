require 'selenium-webdriver'

module SauceDriver
  class << self
    def sauce_endpoint
      return "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub"
    end
 
    def caps
      caps = Hash.new
      if ENV['TEST_PROFILE'].eql?('WINDOWS10_FIREFOX')
        caps = Selenium::WebDriver::Remote::Capabilities.firefox()
        caps['platform'] = 'Windows 10'
        caps['version'] = '48.0'
      elsif ENV['TEST_PROFILE'].eql?('ANDROID_51')
        caps = Selenium::WebDriver::Remote::Capabilities.android()
        caps['appiumVersion'] = '1.5.3'
        caps['deviceName'] = 'Android Emulator'
        caps['deviceType'] = 'phone'
        caps['deviceOrientation'] = 'portrait'
        caps['browserName'] = 'Browser'
        caps['platformVersion'] = '5.1'
        caps['platformName'] = 'Android'
      elsif ENV['TEST_PROFILE'].eql?('IOS_IPHONE6_93')
        caps = Selenium::WebDriver::Remote::Capabilities.iphone()
        caps['appiumVersion'] = '1.5.3'
        caps['deviceName'] = 'iPhone 6 Simulator'
        caps['deviceOrientation'] = 'portrait'
        caps['platformVersion'] = '9.3'
        caps['platformName'] = 'iOS'
        caps['browserName'] = 'Safari'
      elsif ENV['TEST_PROFILE'].eql?('WINDOWS10_CHROME')
        caps = Selenium::WebDriver::Remote::Capabilities.chrome()
        caps['platform'] = 'Windows 10'
        caps['version'] = '53.0'
        caps['screenResolution'] = '1920x1080'
      elsif ENV['TEST_PROFILE'].eql?('WINDOWS10_EDGE')
        caps = Selenium::WebDriver::Remote::Capabilities.edge()
        caps['platform'] = 'Windows 10'
        caps['version'] = '13.10586'
        caps['screenResolution'] = '1920x1080'
      end
      caps['recordVideo'] = false
      caps['build'] = ENV['TRAVIS_BUILD_NUMBER']
      caps['name'] = ENV['TRAVIS_JOB_NUMBER']
      caps['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
      return caps
    end
 
    def new_driver
      Selenium::WebDriver.for :remote, :url => sauce_endpoint, :desired_capabilities => caps
    end
  end
end