require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YouyunWeixin
  class Application < Rails::Application
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :'zh-CN'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.app_config = config_for(:app_config)
    config.active_job.queue_adapter = :sidekiq
    #config.active_job.queue_name_prefix = Rails.env

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

    config.generators do |g|
      g.template_engine :slim
    end

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

  end
end

APP_CONFIG = Rails.application.config.app_config
WECHAT_USER_API = Wechat::Api.new(APP_CONFIG['wechat_user']['appid'],
                                  APP_CONFIG['wechat_user']['secret'],
                                  APP_CONFIG['wechat_user']['access_token'],
                                  20,
                                  true,
                                  APP_CONFIG['wechat_user']['jsapi_ticket'])
WECHAT_DOCTOR_API = Wechat::Api.new(APP_CONFIG['wechat_doctor']['appid'],
                                    APP_CONFIG['wechat_doctor']['secret'],
                                    APP_CONFIG['wechat_doctor']['access_token'],
                                    20,
                                    true,
                                    APP_CONFIG['wechat_doctor']['jsapi_ticket'])
