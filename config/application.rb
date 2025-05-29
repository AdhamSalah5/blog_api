require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BlogApi
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true

    # Autoload lib directory
    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")  

    config.autoload_lib(ignore: %w[assets tasks])

    # Set Sidekiq as the background job adapter
    config.active_job.queue_adapter = :sidekiq       
  end
end
