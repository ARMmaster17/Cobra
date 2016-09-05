require_relative 'frontend/main'
require 'sinatra/activerecord/rake'

task :test do
  ruby "testing/testall.rb"
end

task :seed do
    puts "WARNING: THIS WILL CLEAR THE DATABASE AND ALL OF ITS DATA!"
    Lot.destroy_all
    Zone.destroy_all
    Site.all.destroy_all
    Key.all.destroy_all
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
    key1 = Key.create do |k|
        k.key_identifier = "1111AAAA"
        k.key_secret = "123456789ABCDEFGHI"
        k.read_only = false
    end
    key2 = Key.create do |k|
        k.key_identifier = "AAAA1111"
        k.key_secret = "ABCDEFGHI123456789"
        k.read_only = true
    end
end