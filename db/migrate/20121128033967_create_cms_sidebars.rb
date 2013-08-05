class CreateCmsSidebars < ActiveRecord::Migration
  def change
    create_table :cms_sidebars do |t|
      t.string :name
      t.text :content
      t.timestamps
    end
  end
end
