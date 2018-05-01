ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

module CoordinatesFixtureHelper
  extend self

  def increment_time(base, delta)
    base = DateTime.strptime("#{base}UTC",'%Y%m%d%H%M%S%z').to_time.utc
    base += delta
    return base.strftime('%Y%m%d%H%M%S')
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
