require 'active_support'
require 'base64'
require 'redis'
require 'time'

module ActiveSupport
  module Cache
    
    # RailsRedisCache is Rails 3 cache store implementation using the key value store Redis.
    # 
    # Author::    Peter Schröder  (mailto:phoetmail@googlemail.com)
    # 
    # ==Usage
    # 
    # Add the gem to your Gemfile
    # 
    #   gem "rails_redis_cache"
    # 
    # and configure the cache store
    # 
    #   config.cache_store = ActiveSupport::Cache::RailsRedisCache.new(:url => ENV['RAILS_REDIS_CACHE_URL'])
    # 
    class RailsRedisCache < Store
      
      TIME_PREF = "rails_redis_cache_time"
      VALUE_PREF = "rails_redis_cache_value"
      
      attr_reader :redis
      
      # Initializes the cache store and opens a connection to Redis.
      # 
      #   ActiveSupport::Cache::RailsRedisCache.new(:url => ENV['RAILS_REDIS_CACHE_URL'])
      # 
      # ==== Options:
      # 
      # [url] the url to the Redis instance
      # 
      # ==== More Options:
      # 
      # Have a look at redis-rb and Rails docs for further options
      # 
      def initialize(options={})
        super(options)
        @redis = Redis.connect(options)
      end
      
      # ============================= optional store impl ==============================
      
      def delete_matched(matcher, options = nil)
        @redis.keys("#{VALUE_PREF}_*").map{|key| key[(VALUE_PREF.size + 1)..-1] }.grep(matcher).each do |key| 
          delete_entry(key, options)
        end.size
      end

      def increment(name, amount = 1, options = nil)
        write(name, amount + read(name, options).to_i, options)
      end

      def decrement(name, amount = 1, options = nil)
        increment(name, amount * -1, options)
      end

      def cleanup(options = nil)
        value_keys = @redis.keys("#{VALUE_PREF}_*")
        time_keys = @redis.keys("#{TIME_PREF}_*")
        @redis.del *(value_keys + time_keys)
      end

      def clear(options = nil)
        cleanup(options)
      end
      
      # ============================= basic store impl ==============================
      
      protected
      
      def read_entry(key, options)
        raw_value = @redis.get "#{VALUE_PREF}_#{key}"
        return nil unless raw_value
        
        raw_time = @redis.get("#{TIME_PREF}_#{key}")
        time = raw_time.nil? ? nil : Time.parse(raw_time)
        value = Marshal.load(Base64.decode64(raw_value))
        ActiveSupport::Cache::Entry.create value, time
      end

      def write_entry(key, entry, options)
        value = Base64.encode64(Marshal.dump(entry.value))
        time = Time.now
        @redis.mset "#{VALUE_PREF}_#{key}", value, "#{TIME_PREF}_#{key}", time
        return unless expiry = options[:expires_in]
        @redis.expire "#{VALUE_PREF}_#{key}", expiry
        @redis.expire "#{TIME_PREF}_#{key}", expiry
      end

      def delete_entry(key, options)
        @redis.del "#{VALUE_PREF}_#{key}", "#{TIME_PREF}_#{key}"
      end
            
    end
  end 
end