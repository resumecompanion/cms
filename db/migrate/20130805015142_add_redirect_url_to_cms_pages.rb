class AddRedirectUrlToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :redirect_path, :string 
  end
end
