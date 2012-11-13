class CreateCmsPages < ActiveRecord::Migration
  def change
    create_table :cms_pages do |t|
      t.integer :parent_id
      t.integer :author_id
      t.integer :position, :default => 0
      t.integer :children_count, :default => 0
      t.string :title
      t.string :slug
      t.string :meta_description
      t.string :meta_keywords
      t.text :content
      t.boolean :is_published, :default => true
      t.integer :old_id
      t.timestamps
    end
  end
end