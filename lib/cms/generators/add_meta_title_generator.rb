require 'rails/generators'

module Cms
  module Generators
    class AddMetaTitleGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy add_meta_title_to_page.rb file"

      def copy_migration
        copy_file "migrations/add_meta_title_to_page.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_add_meta_title_to_page.rb.rb"
      end
    end
  end
end