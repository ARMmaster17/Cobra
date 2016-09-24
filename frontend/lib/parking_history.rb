require 'json'
require_relative './external_job'
require_relative '../../shared/lib/data_cache'

##
# Abstracts cachine process for parking historical data.
module ParkingHistory
    def ParkingHistory.get()
        if DataCache.isExpired('history', '4H2E', 30)
            Externaljob.send(uri, 'cobra.outbound.data.history-display')
        end
        return DataCache.get('history', '4H2E')
    end
end