class CreateCmsSettings < ActiveRecord::Migration
  def change
    create_table :cms_settings do |t|
      t.string :key
      t.string :value
      t.string :description
      t.timestamps
    end

    add_index :cms_settings, :key, :unique => true
  end
end
