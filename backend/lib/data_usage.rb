require 'json'
require 'sinatra/activerecord'
require_relative '../../shared/models/lot'
require_relative '../../shared/models/zone'
require_relative '../../shared/models/site'
require_relative '../../shared/lib/data_cache'

##
# Abstracts cachine process for parking area usage calculation.
module DataUsage
    def DataUsage.go(payload)
        target = payload.split("/")
        count = Float(0)
        case target.count
        when 1
            # Site update
            data_site = Site.find_by(short_name: target[0])
            count = (Float(data_site.used_spaces) / Float(data_site.total_spaces)) * 100
        when 2
            # Zone update
            data_site = Site.find_by(short_name: target[0])
            data_zone = data_site.zones.find_by(short_name: target[1])
            count = (Float(data_zone.used_spaces) / Float(data_zone.total_spaces)) * 100
        when 3
            # Lot update
            data_site = Site.find_by(short_name: target[0])
            data_zone = data_site.zones.find_by(short_name: target[1])
            data_lot = data_zone.lots.find_by(short_name: target[2])
            count = (Float(data_lot.used_spaces) / Float(data_lot.total_spaces)) * 100
        else
            # Do nothing, unsupported options given.
        end
        DataCache.set('usage', payload, count)
    end
end