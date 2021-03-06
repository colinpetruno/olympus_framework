# This file is copied to spec/ when you run "rails generate rspec:install"
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'selenium/webdriver'
require 'capybara/rails'
require 'google/apis/calendar_v3'
require 'capybara-screenshot/rspec'

Dir[Rails.root.join('spec', 'helpers', '**/*.rb')].each do |f|
  load(f)
end
Dir[Rails.root.join('spec', 'support', 'mocks', '**/*.rb')].each do |f|
  load(f)
end

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Include helper files
  config.include Rails.application.routes.url_helpers
  config.include AccountCreatorHelper
  config.include Warden::Test::Helpers

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end


 Capybara.register_driver :chrome do |app|
   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
     loggingPrefs: {
       browser: 'ALL'
     }
   )

   Capybara::Selenium::Driver.new(
     app,
    browser: :chrome,
     desired_capabilities: capabilities
   )
 end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[--headless --disable-gpu] },
      'goog:loggingPrefs': {
          browser: 'ALL'
      }
    )

  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities,
      options: options
    )
end

Capybara.default_driver = :chrome
Capybara.default_driver = :headless_chrome if ENV['HEADLESS'] == 1 || ENV['HEADLESS'] == '1'

Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Chromedriver::Logger::TestHooks.for_rspec! if ENV['DEBUG_JS']

# Capybara.asset_host = "http://localhost:3000"
# Capybara::Screenshot.webkit_options = { width: 1280, height: 768 }

# capybara screenshot only really works with selenium
# https://github.com/mattheworiordan/capybara-screenshot/issues/211
# Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
# driver.browser.save_screenshot(path)
# end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
