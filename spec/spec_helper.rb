# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'byebug'
require 'wor/batchifier'
require 'webmock/rspec'
require 'httparty'
require 'support/wrong_strategy'
require 'support/valid_strategy'

include Wor::Batchifier
