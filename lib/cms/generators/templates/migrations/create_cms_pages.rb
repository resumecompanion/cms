class CreateCmsPages < ActiveRecord::Migration
  def change
    create_table :cms_pages do |t|
      t.integer :parent_id
      t.integer :author_id
      t.integer :sidebar_id
      t.integer :position, :default => 0
      t.integer :children_count, :default => 0
      t.string :title
      t.boolean :is_displayed_title, :default => true
      t.string :slug
      t.string :meta_description
      t.string :meta_keywords
      t.text :content
      t.boolean :is_published, :default => true
      t.integer :old_id
      t.timestamps
    end

    add_index :cms_pages, :parent_id
    add_index :cms_pages, :author_id
    add_index :cms_pages, :sidebar_id
    add_index :cms_pages, :slug
    add_index :cms_pages, :is_displayed_title
    add_index :cms_pages, :is_published
  end
end