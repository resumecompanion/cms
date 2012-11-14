require 'rails/generators'

module Cms
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy CMS default files"

      def copy_initialize
        copy_file "initializers/cms.rb", "config/initializers/cms.rb"
      end

      def copy_migration
        copy_file "migrations/devise_create_cms_users.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_devise_create_cms_users.rb"
        sleep 0.1
        copy_file "migrations/create_cms_navigations.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_create_cms_navigations.rb"
        sleep 0.1
        copy_file "migrations/create_cms_files.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_create_cms_files.rb"
        sleep 0.1
        copy_file "migrations/create_cms_pages.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_create_cms_pages.rb"
        sleep 0.1
        copy_file "migrations/create_cms_settings.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_create_cms_settings.rb"
      end

      # def show_readme
      #     readme "README"
      # end

    end
  end
end