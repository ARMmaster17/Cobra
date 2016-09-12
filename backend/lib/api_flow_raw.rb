require 'json'
require 'sinatra/activerecord'
require_relative '../../shared/models/lot'
require_relative '../../shared/models/zone'
require_relative '../../shared/models/site'

##
# Abstracts cachine process for parking area usage calculation.
module ApiFlowRaw
    def ApiFlowRaw.go(payload)
        parameters = JSON.parse(payload)
        data_site = Site.find_by(short_name: parameters['site'])
        data_zone = data_site.zones.find_by(short_name: parameters['zone'])
        data_lot = data_zone.lots.find_by(short_name: parameters['lot'])
        if parameters['direction'].eql?('in')
            data_lot.used_spaces += 1
        elsif parameters['direction'].eql?('out')
            data_lot.used_spaces -= 1
        end
        data_lot.save
    end
end