if Rails.env.production?
  uri = ENV["REDIS_URL"]
  Redis.current = Redis.new(:url => uri)
  Resque.redis = Redis.current
end
