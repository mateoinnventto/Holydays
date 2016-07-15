class RedisHelper
	@@redis = Redis.new

	def self.set(key, value, expiration = 60*60*24*30)
		@@redis ||= Redis.new
		@@redis.set(key, value, {ex: expiration})
	end

	def self.get(key)
		@@redis ||= Redis.new
		@@redis.get(key)
	end

	def self.delete(key)
		@@redis ||= Redis.new
		@@redis.del(key)
	end
	
end