class AddDefaultThemeKey < ActiveRecord::Migration
  def up
    Cms::Setting.create key: 'global:theme', value: 'resumecompanion', description: 'dusquss name'
  end

  def down
    Cms::Setting.find_by_name('global:theme').destroy
  end
end
