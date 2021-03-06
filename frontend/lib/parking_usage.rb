require 'json'
require_relative './external_job'
require_relative '../../shared/lib/data_cache'

##
# Abstracts cachine process for parking area usage calculation.
module ParkingUsage
    def ParkingUsage.get_site(site)
        value = ParkingUsage.get(site)
        if value.nil?
            return 0
        else
            return JSON.parse(value['value'])['value']
        end
    end
    def ParkingUsage.get_zone(site, zone)
        uri = "#{site}/#{zone}"
        value = ParkingUsage.get(uri)
        if value.nil?
            return 0
        else
            return JSON.parse(value['value'])['value']
        end
    end
    def ParkingUsage.get_lot(site, zone, lot)
        uri = "#{site}/#{zone}/#{lot}"
        value = ParkingUsage.get(uri)
        if value.nil?
            return 0
        else
            return JSON.parse(value['value'])['value']
        end
    end
    def ParkingUsage.get(uri)
        if DataCache.isExpired('usage', uri, 30)
            Externaljob.send(uri, 'cobra.outbound.data.usage')
        end
        return DataCache.get('usage', uri)
    end
end