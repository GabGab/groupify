require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Groupify
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers

    # Outputting links in https
    Rails.application.routes.default_url_options[:protocol] = "https"

    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :en

    require File.expand_path("../../lib/settings_file", __FILE__)

  end
end
