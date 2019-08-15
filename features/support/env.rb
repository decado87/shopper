# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
ENV['RAILS_ENV'] ||= 'test'

require 'cucumber/rails'
require 'capybara/cucumber'
require 'rack_session_access/capybara'

ActionController::Base.allow_forgery_protection = true
Capybara.server_port = 31337

@@base_url = "http://127.0.0.1:#{Capybara.server_port}"

Before do
  DatabaseCleaner.clean_with(:truncation)
  Capybara.default_max_wait_time = 3
end

After do
  Capybara.reset_sessions!
end


Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# Capybara.javascript_driver = :chrome
Capybara.javascript_driver = :selenium_chrome_headless

ActionController::Base.allow_rescue = false

Cucumber::Rails::Database.javascript_strategy = :transaction