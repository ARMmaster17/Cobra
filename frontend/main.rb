#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'json'
require 'sinatra/activerecord'
require 'rack-flash'
require 'securerandom'
require 'bunny'
require 'newrelic_rpm'
require_relative '../config/environments'
require_relative '../shared/models/lot'
require_relative '../shared/models/zone'
require_relative '../shared/models/site'
require_relative './lib/external_job'
require_relative './lib/api_key'
require_relative './lib/parking_usage'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'


enable :sessions
use Rack::Flash

Externaljob.init()
ApiKey.init()
DataCache.init()

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
    # Defines if current user is a super user.
    def admin?
        if ENV['CI'] || ENV['RACK_ENV'].eql?('TEST')
            return true
        elsif session[:admin_auth].nil?
            return false
        else
            return session[:admin_auth]
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
##################################
# Local and SSO login endpoints. #
##################################
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
##
# Step 1 of GitHub SSO OAuth2 login pipeline.
get '/auth/v1/sso/github' do
    redirect '/secured/admin' unless !admin?
    redirect "https://github.com/login/oauth/authorize?scope=user:email&client_id=#{ENV['GITHUB_CLIENT_ID']}"
end
##
# Steps 2 and 3 of the GitHub SSO OAuth2 login pipeline.
get '/auth/v1/sso/github/callback' do
    # get temporary GitHub code...
    session_code = request.env['rack.request.query_hash']['code']

    # ... and POST it back to GitHub
    result = RestClient.post('https://github.com/login/oauth/access_token',
                            {:client_id => ENV['GITHUB_CLIENT_ID'],
                            :client_secret => ENV['GITHUB_CLIENT_SECRET'],
                            :code => session_code},
                            :accept => :json)

    # extract the token and granted scopes
    session[:access_token] = JSON.parse(result)['access_token']
    auth_result = JSON.parse(RestClient.get('https://api.github.com/user', {:params => {:access_token => session[:access_token]}}))
    session[:admin_username] = auth_result['login']
    session[:admin_profilepic] = auth_result['avatar_url']
    if session[:admin_username].eql?("ARMmaster17")
        session[:admin_auth] = true
    else
        session[:admin_auth] = false
    end
    redirect '/secured/admin'
end
#################################################
# Administration and manual data control pages. #
#################################################
get '/secured/admin' do
    redirect '/auth/v1/sso/github' unless admin?
    redirect '/secured/admin/sites'
end
get '/secured/admin/api/generate/:permissions' do
    redirect '/auth/v1/sso/github' unless admin?
    @key = ApiKey.create(params[:permissions])
    @meta_name = "Admin - API Key Generation"
    slim :admin_api_key_generate
end
get '/secured/admin/sites' do
    redirect '/auth/v1/sso/github' unless admin?
    @meta_name = 'Admin - Sites'
    @data_sites = Site.all
    slim :admin_site_list
end
get '/secured/admin/:site' do
    redirect '/auth/v1/sso/github' unless admin?
    @data_site = Site.find_by(short_name: params[:site])
    @meta_name = "Admin - #{@data_site.full_name} Site"
    # TODO: remove once detail page is complete.
    redirect "/secured/admin/#{params[:site]}/zones"
    slim :admin_site_detail
end
post '/secured/admin/:site' do
    redirect '/auth/v1/sso/github' unless admin?
    if params['operation'].eql?('Create')
        temp_record = Site.create do |s|
            s.full_name = params['full-name']
            s.short_name = params['short-name']
        end
        redirect "/secured/admin/#{params['short-name']}"
    elsif params['operation'].eql?('Update')
        temp_record = Site.find_by(id: params['id'])
        temp_record.full_name = params['full-name']
        temp_record.save
        redirect "/secured/admin/#{params[:site]}"
    elsif params['operation'].eql?('Delete')
        temp_record = Site.find_by(id: params['id'])
        temp_record.destroy
        redirect '/secured/admin/sites'
    end
end
get '/secured/admin/:site/zones' do
    redirect '/auth/v1/sso/github' unless admin?
    @meta_name = 'Admin - Zones'
    @data_site = Site.find_by(short_name: params[:site])
    @data_zones = @data_site.zones
    slim :admin_zone_list
end
get '/secured/admin/:site/:zone' do
    redirect '/auth/v1/sso/github' unless admin?
    @data_site = Site.find_by(short_name: params[:site])
    @data_zone = @data_site.zones.find_by(short_name: params[:zone])
    @meta_name = "Admin - #{@data_zone.full_name} Zone"
    # TODO: remove once detail page is complete.
    redirect "/secured/admin/#{params[:site]}/#{params[:zone]}/lots"
    slim :admin_zone_detail
end
post '/secured/admin/:site/:zone' do
    redirect '/auth/v1/sso/github' unless admin?
    if params['operation'].eql?('Create')
        temp_record = Site.find_by(short_name: params[:site]).zones.create do |z|
            z.full_name = params['full-name']
            z.short_name = params['short-name']
        end
        redirect "/secured/admin/#{params[:site]}/#{params['short-name']}"
    elsif params['operation'].eql?('Update')
        temp_record = Zone.find_by(id: params['id'])
        temp_record.full_name = params['full-name']
        temp_record.save
        redirect "/secured/admin/#{params[:site]}/#{params[:zone]}"
    elsif params['operation'].eql?('Delete')
        temp_record = Zone.find_by(id: params['id'])
        temp_record.destroy
        redirect "/secured/admin/#{params[:site]}/zones"
    end
end
get '/secured/admin/:site/:zone/lots' do
    redirect '/auth/v1/sso/github' unless admin?
    @meta_name = 'Admin - Lots'
    @data_site = Site.find_by(short_name: params[:site])
    @data_zone = @data_site.zones.find_by(short_name: params[:zone])
    @data_lots = @data_zone.lots
    slim :admin_lot_list
end
get '/secured/admin/:site/:zone/:lot' do
    redirect '/auth/v1/sso/github' unless admin?
    @data_site = Site.find_by(short_name: params[:site])
    @data_zone = @data_site.zones.find_by(short_name: params[:zone])
    @data_lot = @data_zone.lots.find_by(short_name: params[:lot])
    @meta_name = "Admin - #{@data_lot.full_name} Lot"
    # TODO: remove once detail page is complete.
    redirect "/secured/admin/#{params[:site]}/#{params[:zone]}/lots"
    slim :admin_lot_detail
end
post '/secured/admin/:site/:zone/:lot' do
    redirect '/auth/v1/sso/github' unless admin?
    if params['operation'].eql?('Create')
        temp_record = Site.find_by(short_name: params[:site]).zones.find_by(short_name: params[:zone]).lots.create do |l|
            l.full_name = params['full-name']
            l.short_name = params['short-name']
            l.is_staff_only = params['is-staff-only'].eql?('Yes') && !params['is-staff-only'].nil?
            l.is_restricted_access = params['is-restricted-access'].eql?('Yes') && !params['is-restricted-access'].nil?
            l.is_trackable = params['is-trackable'].eql?('Yes') && !params['is-trackable'].nil?
            l.total_spaces = params['total-spaces']
            l.used_spaces = params['used-spaces']
        end
        redirect "/secured/admin/#{params[:site]}/#{params[:zone]}/#{params['short-name']}"
    elsif params['operation'].eql?('Update')
        temp_record = Lot.find_by(id: params['id'])
        temp_record.full_name = params['full-name']
        temp_record.is_staff_only = params['is-staff-only'].eql?('Yes') && !params['is-staff-only'].nil?
        temp_record.is_restricted_access = params['is-restricted-access'].eql?('Yes') && !params['is-restricted-access'].nil?
        temp_record.is_trackable = params['is-trackable'].eql?('Yes') && !params['is-trackable'].nil?
        temp_record.total_spaces = params['total-spaces']
        temp_record.used_spaces = params['used-spaces']
        temp_record.save
        redirect "/secured/admin/#{params[:site]}/#{params[:zone]}/#{params[:lot]}"
    elsif params['operation'].eql?('Delete')
        temp_record = Lot.find_by(id: params['id'])
        temp_record.destroy
        redirect "/secured/admin/#{params[:site]}/#{params[:zone]}/lots"
    end
end
####################
# Live data pages. #
####################
get '/data' do
    @meta_name = 'All Sites'
    @data_sites = Site.all
    slim :list_sites
end
get '/data/:site' do
    @data_site = Site.find_by(short_name: params[:site])
    @data_zones = @data_site.zones
    @meta_name = 'Zones'
    slim :list_zones
end
get '/data/:site/:zone' do
    @data_site = Site.find_by(short_name: params[:site])
    @data_zone = @data_site.zones.find_by(short_name: params[:zone])
    @data_lots = @data_zone.lots
    @meta_name = 'Lots'
    slim :list_lots
end
get '/data/:site/:zone/:lot' do
    @meta_name = params[:lot] + ' Lot'
    @api_endpoint = "/api/v1/web/usage/#{params[:site]}/#{params[:zone]}/#{params[:lot]}"
    # Don't pass in any data. This will be handled by Angular through the API since this needs to be updated in real time.
    slim :status_lot
end
###################################################################
# API endpoints for embedded data collection and display devices. #
###################################################################
##
# API endpoint for dumb data collection endpoints recording inbound vehicles.
get '/api/v1/flow/inbound/raw/:site/:zone/:lot' do
    if !ApiKey.auth(params[:id], params[:secret], 'w')
        status 403
        return "Not authorized"
    end
    data = Hash.new
    data['site'] = params[:site]
    data['zone'] = params[:zone]
    data['lot'] = params[:lot]
    data['direction'] = 'in'
    Externaljob.send(data.to_json, "cobra.outbound.api.flow.raw")
    status 200
    return "Transaction queued."
end
##
# API endpoint for dumb data collection endpoints recording outbound vehicles.
get '/api/v1/flow/outbound/raw/:site/:zone/:lot' do
    if !ApiKey.auth(params[:id], params[:secret], 'w')
        status 403
        return "Not authorized"
    end
    data = Hash.new
    data['site'] = params[:site]
    data['zone'] = params[:zone]
    data['lot'] = params[:lot]
    data['direction'] = 'out'
    Externaljob.send(data.to_json, "cobra.outbound.api.flow.raw")
    status 200
    return "Transaction queued."
end
##
# API endpoint for smart data collection endpoints recording inbound tagged vehicles.
get '/api/v1/flow/inbound/marked/:site/:zone/:lot/:vhid' do
    # Do nothing right now. Needs to be implemented on backend first.
end
##
# API endpoint for smart data collection endpoints recording outbound tagged vehicles.
get '/api/v1/flow/outbound/marked/:site/:zone/:lot/:vhid' do
    # Do nothing right now. Needs to be implemented on backend first.
end
##
# API endpoint for data display units to show data about a specified lot.
get '/api/v1/web/stats/:site/:zone/:lot' do
    # No API key check since web requests don't transmit secured info.
    data_site = Site.find_by(short_name: params[:site])
    data_zone = data_site.zones.find_by(short_name: params[:zone])
    data_lot = data_zone.lots.find_by(short_name: params[:lot])
    return data_lot.to_json
end
##
# API endpoint for data display units to show graph containing lot usage.
get '/api/v1/web/usage/:site/:zone/:lot' do
    # No API key check since web requests don't transmit secured info.
    data = Hash.new
    data['usage'] = ParkingUsage.get_lot(params[:site], params[:zone], params[:lot])
    return data.to_json
end
##
# API endpoint for data display units to show historical lot usage including
# extrapolated data points for specified lot.
get '/api/v1/web/history/:site/:zone/:lot' do
    # No API key check since web requests don't transmit secured info.
    data = Hash.new
    # TODO: Get all data points from the past 4 hours plus two extrapolated data points.
    return data.to_json
end
##
# Catch-all 404 error handler
not_found do
    @meta_name = '404'
    slim :error_404
end