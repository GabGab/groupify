require "rack/ssl_middleware"
Rails.application.config.middleware.use(Rack::Sociabliz::Ssl)
