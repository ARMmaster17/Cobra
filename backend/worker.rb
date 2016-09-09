#!/usr/bin/env ruby
require 'rubygems'
require 'rest-client'
require 'json'
require 'bunny'
require 'sinatra/activerecord'
require 'newrelic_rpm'
#require_relative '../config/environments'
require_relative '../shared/models/lot'
require_relative '../shared/models/zone'
require_relative '../shared/models/site'

conn = Bunny.new(ENV['RABBITMQ_BIGWIG_RX_URL'])
conn.start

ch = conn.create_channel
q1  = ch.queue("cobra.outbound.api.flow.raw")

q1.subscribe(:block => true) do |delivery_info, metadata, payload|
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

while true
    # Do nothing
end
