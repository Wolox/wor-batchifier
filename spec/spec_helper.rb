# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start

require 'byebug'
require 'wor/batchifier'
require 'webmock/rspec'
require 'httparty'
