require 'rwanda'
require 'rwanda/rails'
require 'action_view'
require 'pry'

RSpec.configure do |config|
  config.color = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end