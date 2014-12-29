ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
  config.order = :random

  config.before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end
end
