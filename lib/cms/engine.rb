require 'rack/ssl-enforcer'

class LazyRegexp
  def initialize(regex_string)
    @regex_string = regex_string
  end

  def =~(x)
    x =~ Regexp.new("#{Cms::Engine.mounted_path}#{@regex_string}")
  end

  def is_a?(clazz)
    return true if clazz == Regexp
    super
  end
end

module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms
    @@mpath = nil
    
    def self.mounted_path
      if @@mpath
        return @@mpath.spec.to_s == '/' ? '' : @@mpath.spec.to_s
      end
      
      # -- find our path -- #
      
      route = Rails.application.routes.routes.detect { |route| route.app == self }
        
      if route
        @@mpath = route.path
      end

      return @@mpath.spec.to_s == '/' ? '' : @@mpath.spec.to_s
    end

    
    initializer 'cms.ssl', before: :build_middleware_stack do |app|
      unless Rails.env.development?
        app.middleware.use Rack::SslEnforcer, only: LazyRegexp.new("/users/.*")
        app.middleware.use Rack::SslEnforcer, only: LazyRegexp.new("/admin/.*"), ignore: %r{/assets.*}, strict: true
      end
    end
    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end

  end
end
