require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MeettricsWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.default_locale = :en

    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile += %w( *.eot *.woff *.ttf *.otf *.svg )

    config.autoload_paths << Rails.root.join("app", "inputs")
    config.autoload_paths << Rails.root.join("app", "policies", "**", "*.rb")
    config.autoload_paths << Rails.root.join("app", "presenters", "**", "*.rb")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :resque

    # https://github.com/sass/sassc-ruby/issues/167
    config.assets.configure do |env|
      env.export_concurrent = false
    end
  end
end
