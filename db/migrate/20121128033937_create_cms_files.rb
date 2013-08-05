class CreateCmsFiles < ActiveRecord::Migration
  def change
    create_table :cms_files do |t|
      t.integer :cms_user_id
      t.string :image
      t.string :title
      t.timestamps
    end

    add_index :cms_files, :cms_user_id
  end
end
