require 'json'
require_relative './api_flow_raw'
require_relative './data_usage'
require_relative '../../shared/lib/data_cache'

##
# Proccesses incoming RabbitMQ messages
module Processor
    def Processor.init()
        DataCache.init
    end
    def Processor.go(data)
        if data['type'].eql?("cobra.outbound.api.flow.raw")
            ApiFlowRaw.go(data['payload'])
        elsif data['type'].eql?("cobra.outbound.data.usage")
            DataUsage.go(data['payload'])
        else
            # Do nothing, invalid command.
        end
    end
end