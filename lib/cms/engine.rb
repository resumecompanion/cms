module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end
    
    initializer "cms.precompile_assets" do |app|
      app.config.assets.precompile += %w( cms/application.js, cms/application.css cms/resumegenius.css cms/resumecompanion.css  cms/businessplantoday.css cms/admin.js cms/admin.css )
      app.config.assets.precompile += %w( cms/plugin/ckeditor/init.js cms/plugin/ckeditor/*)
    end

  end
end
