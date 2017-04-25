redis_config = $settings_file[:redis]
redis_url = "redis://#{redis_config["host"]}:#{redis_config["port"]}/#{redis_config["db"].to_i}"

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url
  }
end
