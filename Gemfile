source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "govuk_app_config"
gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "pg"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "sentry-rails"
gem "sentry-ruby"

gem "dartsass-rails", "~> 0.5.0"
gem "jsbundling-rails"
gem "sprockets-rails"

group :test do
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-json", require: false
end

group :development, :test do
  gem "brakeman", require: false
  gem "capybara"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "rubocop-govuk", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "i18n-debug"
end
