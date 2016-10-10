CarrierWave.configure do |config|
  if Rails.env == 'test'
    config.storage = :upyun
    config.upyun_username = "test"
    config.upyun_password = 'imconfused'
    config.upyun_bucket = "youyun-test"
    config.upyun_bucket_host = "http://youyun-test.b0.upaiyun.com"
  else
    config.storage = :upyun
    config.upyun_username = APP_CONFIG['upaiyun_name']
    config.upyun_password = APP_CONFIG['upaiyun_password']
    config.upyun_bucket = APP_CONFIG['upaiyun_bucket']
    config.upyun_bucket_host = APP_CONFIG['upaiyun_bucket_host']
  end
end
