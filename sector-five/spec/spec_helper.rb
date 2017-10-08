require 'simplecov'
require 'rspec/simplecov'

SimpleCov.minimum_coverage 95
SimpleCov.start

RSpec::SimpleCov.start

RSpec.configure do |config|
  # configure RSpec here
end