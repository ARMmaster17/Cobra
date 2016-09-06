require 'bunny'
require 'json'

##
# Launches a one-way data job with RabbitMQ
module Externaljob
    def Externaljob.init()
        @c = Bunny.new(ENV['RABBITMQ_BIGWIG_TX_URL'])
        @c.start
        @ch = @c.create_channel
    end
    def Externaljob.send(payload, queue)
        q  = @ch.queue(queue)
        x  = @ch.default_exchange
        x.publish(payload, :routing_key => q.name)
    end
end