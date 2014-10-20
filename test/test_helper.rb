require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'faker'
require 'capybara/rails'
require_relative 'support/test_password_helper'

# Capybara.default_driver = :selenium

class ActiveSupport::TestCase
  include TestPasswordHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def logged_in_session
    { current_user_id: users(:one).id }
  end
end

class ActionController::TestCase
  def assert_invalid_model(model_name)
    assert assigns[model_name], "Should have a #{model_name}"
    assert assigns[model_name].invalid?, "Should have an invalid #{model_name}"
  end

  def assert_saved_model(model_name)
    assert assigns[model_name], "Should have a #{model_name}"
    assert assigns[model_name].persisted?, "#{model_name} should be persisted"
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def login(user = users(:one), password = default_password)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Login"
  end
end

ActiveRecord::FixtureSet.context_class.send :include, TestPasswordHelper
