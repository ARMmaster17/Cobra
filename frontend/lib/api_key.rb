require 'redis'
require 'json'

##
# Can pull and push keys from the API key storage.
module ApiKey
    def ApiKey.init()
        @redis = Redis.new(url: ENV["REDIS_URL"])
    end
    def ApiKey.create(permissions)
        key = Hash.new
        key['identifier'] = SecureRandom.urlsafe_base64(10)
        key['secret'] = SecureRandom.urlsafe_base64(25)
        key['permissions'] = permissions
        @redis.set(key['identifier'], key.to_json)
        return key
    end
    def ApiKey.auth(identifier, secret, permission)
        key = Hash.new
        begin
            key = JSON.parse(@redis.get)
        rescue
            # Key not found
            return false
        end
        if key['secret'].eql?(secret) and key['permissions'].include?(permission)
            return true
        else
            return false
        end
    end
end