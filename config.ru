# This file is used by Rack-based servers to start the application.
puts "[WARNING] $GITHUB_KEY is not defined. Logging in via github will not work correctly." if !ENV['GITHUB_KEY']
puts "[WARNING] $GITHUB_SECRET is not defined. Logging in via github will not work correctly." if !ENV['GITHUB_SECRET']

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
