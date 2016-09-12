require 'json'
require_relative './external_job'
require_relative '../../shared/lib/data_cache'

##
# Abstracts cachine process for parking area usage calculation.
module ParkingUsage
    def ParkingUsage.get_site(site)
        value = ParkingUsage.get(site)
        #puts "BLBLBL" + value
        if value.nil?
            return 0
        else
            return JSON.parse(value)['value']
        end
    end
    def ParkingUsage.get_zone(site, zone)
        uri = "#{site}/#{zone}"
        value = ParkingUsage.get(uri)
        #puts "BLBLBL" + value
        if value.nil?
            return 0
        else
            return JSON.parse(value)['value']
        end
    end
    def ParkingUsage.get_lot(site, zone, lot)
        uri = "#{site}/#{zone}/#{lot}"
        value = ParkingUsage.get(uri)
        #puts "BLBLBL" + value
        if value.nil?
            return 0
        else
            return JSON.parse(value)['value']
        end
    end
    def ParkingUsage.get(uri)
        if DataCache.isExpired('usage', uri, 10000)
            puts 5
            Externaljob.send(uri, 'cobra.outbound.data.usage')
        end
        puts uri
        return DataCache.get('usage', uri)
    end
end