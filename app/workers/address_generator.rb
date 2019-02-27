require 'address'
class AddressGenerator
  include Sidekiq::Worker
  def perform
    addresses = []
    address_length = Figaro.env.ADDRESS_LENGTH.to_i
    Figaro.env.MAX_ADDRESS_GENERATE.to_i.times do
      addresses << Address.generate(address_length)
    end
    store_addresses(addresses)
  end

  private
  def store_addresses(addresses)
    address_key = Figaro.env.REDIS_ADDRESS_KEY
    old_addresses = $redis.smembers(address_key)
    $redis.srem(address_key, old_addresses) if old_addresses.count > 0
    $redis.sadd(address_key, addresses)
    $redis.set(Figaro.env.REDIS_LAST_RUN_KEY, Time.zone.now.to_i)
  end
end