ENV["RAILS_ENV"] ||= "test"

# Ensure the test database exists: if missing, auto-run db:prepare and retry.
begin
  require_relative "../config/environment"
rescue => e
  if e.instance_of?(ActiveRecord::NoDatabaseError)
    warn "[test] Database not found. Running `bin/rails db:prepare` for test environment..."
    system({"RAILS_ENV" => "test"}, "bin/rails db:prepare")
    require_relative "../config/environment"
  else
    raise
  end
end

require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
