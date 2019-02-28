module UsersConcern
  extend ActiveSupport::Concern

  def fetch_address
    $redis.spop(Figaro.env.REDIS_ADDRESS_KEY)
  end

  private

  def fetch_remaining_time
    last_run_at = $redis.get(Figaro.env.REDIS_LAST_RUN_KEY).to_i
    return 1 if last_run_at.zero?

    time_diff = (Time.zone.now - Time.zone.at(last_run_at.to_i)).to_i
    time_escaped = time_diff > 60 ? (time_diff / 60) : 1
    12 - time_escaped
  end
end
