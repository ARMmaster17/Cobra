require 'dalli'
require 'json'
require 'time'

##
# Deals with data caching using MemCachier
module DataCache
    def DataCache.init()
        @cache = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"],
                     :failover => true,
                     :socket_timeout => 1.5,
                     :socket_failure_delay => 0.2,
                     :pool_size => 4
                    })
    end
    def DataCache.get(table, key)
        data = @cache.get("data-#{table}-#{key}")
        if data.nil?
            return nil
        else
            return data['payload']
        end
    end
    def DataCache.set(table, key, value)
        payload = Hash.new
        payload['value'] = value
        payload['last-modified'] = Time.new
        @cache.set("data-#{table}-#{key}", payload.to_json)
    end
    def DataCache.isExpired(table, key, seconds)
        item = DataCache.get(table, key)
        if item.nil?
            return false
        end
        return Time.parse(item['last-modified']) + seconds < Time.new
    end
end