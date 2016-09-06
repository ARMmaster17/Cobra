require 'bunny'
require 'json'

module Externaljob
    def Externaljob.send(payload, queue)
        c = Bunny.new(ENV['RABBITMQ_BIGWIG_TX_URL'])
        c.start
        ch = c.create_channel
        q  = ch.queue(queue)
        x  = ch.default_exchange
        x.publish(payload, :routing_key => q.name)
    end
end