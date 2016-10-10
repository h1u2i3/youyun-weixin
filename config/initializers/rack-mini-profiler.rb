if Rails.env == 'staging'
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
