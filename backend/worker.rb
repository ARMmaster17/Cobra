#!/usr/bin/env ruby
require 'rubygems'
require 'bunny'
require 'newrelic_rpm'
require 'json'
require_relative './lib/processor'

DataCache.init

conn = Bunny.new(ENV['RABBITMQ_BIGWIG_RX_URL'])
conn.start
ch = conn.create_channel
q = ch.queue("cobra.outbound")

q.subscribe(:block => true) do |delivery_info, metadata, payload|
    data = Hash.new
    data = JSON.parse(payload)
    Processor.go(data)
    #ch.ack(delivery_info.delivery_tag)
end

#sleep

while true
    # Do nothing.
end
