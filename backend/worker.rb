#!/usr/bin/env ruby
require 'rubygems'
require 'rest-client'
require 'json'
require 'bunny'

conn = Bunny.new(ENV['RABBITMQ_BIGWIG_RX_URL'])
conn.start

ch = conn.create_channel
q  = ch.queue("cobra.outbound")

q.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end
while true

end
