#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'json'
require 'sinatra/activerecord'
require 'rack-flash'
require 'securerandom'
require_relative '../config/environments'
require_relative '../shared/models/lot'
require_relative '../shared/models/zone'
require_relative '../shared/models/site'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'


enable :sessions
use Rack::Flash

helpers do
    ##
    # Defines if current user is logged in.
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
    # Defines if current user is a super user. (DISABLE IN PRODUCTION)
    def admin?
        return true
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
        @meta_name = 'Login'
        slim :login
    end
end
##
# Login endpoint for local domain logins. (No SSO)
post '/auth/v1/local' do
    # TODO: Verify login credentials and authenticiate user.
    redirect '/data'
end
get '/data/sites' do
    @meta_name = 'All Sites'
    @data_sites = Site.all
    slim :list_sites
end
get '/data/:site' do
    # TODO: Fetch site status from DB.
    @meta_name = site_name + ' Site'
    @data_site = Site.find_by(short_name: params[:site])
    slim :status_site
end
get '/data/:site/zones' do
    @data_site = Site.find_by(short_name: params[:site])
    @data_zones = @data_site.zones
    @meta_name = 'Zones'
    slim :list_zones
end
get '/data/:site/:zone/lots' do
    @meta_name = 'Lots'
    slim :list_lots
end
get '/data/:site/:zone' do
    @meta_name = zone_name + ' Zone'
    slim :status_zone
end
get '/data/:site/:zone/:lot' do
    @meta_name = lot_name + ' Lot'
    slim :status_lot
end
get '/data' do
    redirect '/data/sites'
end
###################################################################
# API endpoints for embedded data collection and display devices. #
###################################################################
##
# API endpoint for dumb data collection endpoints recording inbound vehicles.
get '/api/v1/flow/inbound/raw/:site/:zone/:lot' do
    
end
##
# API endpoint for dumb data collection endpoints recording outbound vehicles.
get '/api/v1/flow/outbound/raw/:site/:zone/:lot' do
    
end
##
# API endpoint for smart data collection endpoints recording inbound tagged vehicles.
get '/api/v1/flow/inbound/marked/:site/:zone/:lot/:vhid' do
    
end
##
# API endpoint for smart data collection endpoints recording outbound tagged vehicles.
get '/api/v1/flow/outbound/marked/:site/:zone/:lot/:vhid' do
    
end
##
# API endpoint for data display units to show how full a specified lot is.
get '/api/v1/display/usage/:site/:zone/:lot' do
    # TODO: return the result as JSON.
end
##
# Catch-all 404 error handler
not_found do
    @meta_name = '404'
    slim :error_404
end