# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Set secret_key_base from environment variable for production
if Rails.env.production? && ENV['SECRET_KEY_BASE'].present?
  Rails.application.config.secret_key_base = ENV['SECRET_KEY_BASE']
end
