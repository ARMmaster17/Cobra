#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'json'
require 'sinatra/activerecord'
require 'rack-flash'
require 'securerandom'
#require_relative '../config/environments'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'


enable :sessions
use Rack::Flash

helpers do
    ##
    # Defines if current user is logged in
    def login?
        if ENV['CI']
            return true
        elsif session[:authusr].nil?
            return false
        else
            return true
        end
    end
    ##
    # Generates a new session key to use for verifying API calls
    def gen_api_key!
        session[:apikey] = SecureRandom.urlsafe_base64(25)
    end
end
##
# Route handler for home page
get '/' do
    @meta_name = 'Home'
    slim :index
end
##
# Route handler for login page.
get '/login' do
    if login?
        redirect '/data'
    else
        slim :login
    end
end
##
# Login endpoint for local domain logins. (No SSO)
post '/auth/v1/local' do
    # TODO: Verify login credentials and authenticiate user.
    redirect '/data'
end
get '/data/zones' do
    # TODO: Fetch all zones from DB.
    slim :list_zones
end
get '/data/:zone/lots' do
    slim :list_lots
end
get '/data/:zone' do
    slim :status_zone
end
get '/data/:zone/:lot' do
    slim :status_lot
end
get '/data' do
    slim :status_all
end
#######################################################
# API endpoints for embedded data collection devices. #
#######################################################
##
# API endpoint for dumb data collection endpoints recording inbound vehicles.
get '/api/v1/flow/inbound/raw/:zone/:lot' do
    
end
##
# API endpoint for dumb data collection endpoints recording outbound vehicles.
get '/api/v1/flow/outbound/raw/:zone/:lot' do
    
end
##
# API endpoint for smart data collection endpoints recording inbound tagged vehicles.
get '/api/v1/flow/inbound/marked/:zone/:lot/:vhid' do
    
end
##
# API endpoint for smart data collection endpoints recording outbound tagged vehicles.
get '/api/v1/flow/outbound/marked/:zone/:lot/:vhid' do
    
end
##
# Catch-all 404 error handler
not_found do
    @meta_name = '404'
    slim :error_404
end