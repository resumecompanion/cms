class AddNoIndexToPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :no_index, :boolean, default: false
  end
end
