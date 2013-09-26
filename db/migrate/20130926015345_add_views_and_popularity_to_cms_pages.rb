class AddViewsAndPopularityToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :views, :integer, default: 0
    add_column :cms_pages, :popularity, :float, default: 0.0
    add_index :cms_pages, :popularity
  end
end
