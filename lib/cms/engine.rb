require 'rack/ssl-enforcer'
module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms
    
    initializer :ssl do |app|
      unless Rails.env.development?
        app.middleware.use Rack::SslEnforcer, only: %r{/users/.*}
        app.middleware.use Rack::SslEnforcer, only: %r{/admin/.*}, ignore: %r{/assets.*}, strict: true
      end
    end
    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end

  end
end
