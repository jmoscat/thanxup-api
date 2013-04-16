  Sidekiq.configure_server do |config|
    config.redis = { url:'redis://thanxup-worker:19032011@pub-redis-10664.us-east-1-3.2.ec2.garantiadata.com:10664'}
  end

  Sidekiq.configure_client do |config|
    config.redis = { url:'redis://thanxup-worker:19032011@pub-redis-10664.us-east-1-3.2.ec2.garantiadata.com:10664' }
  end
