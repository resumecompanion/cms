class AddMetaTitleToPage < ActiveRecord::Migration
  def change
    add_column :cms_pages, :meta_title, :string
  end
end
