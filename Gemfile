source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "base32" # for generating base32 strings for otp
gem "bcrypt"
gem "bootstrap", "~> 4.5"
gem "browser"
gem "bugsnag"
gem "chewy"
gem "country_select"
gem "devise"
gem "email_validator"
gem "google-api-client", "~> 0.34"
gem "font-ionicons-rails"
gem "mixpanel-ruby"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "pagy"
gem "pg"
gem "portunus" # , path: "/Users/colinpetruno/Projects/portunus"
gem "puma"
gem "pundit"
gem "rails", "~> 6.0.0"
gem "redis"
gem "resque"
gem "resque-pool"
gem "rotp"
gem "rqrcode"
gem "sassc-rails"
gem "sendgrid-ruby"
gem "simple_form"
gem "stripe"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webauthn"
gem "webpacker", "~> 4.0"

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", ">= 2.15"
  gem "capybara-screenshot"
  gem "capybara-chromedriver-logger"
  gem "faker"
  gem "letter_opener"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails", "~> 3.8"
  gem "simplecov", require: false
end

group :development do
  gem "better_errors"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "timecop"
  gem "webdrivers"
end

