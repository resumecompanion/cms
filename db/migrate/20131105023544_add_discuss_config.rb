class AddDiscussConfig < ActiveRecord::Migration
  def up
    Cms::Setting.create key: 'global:disqus:shortname', value: 'resumecompanioncms', description: 'dusquss name'
  end

  def down
    Cms::Setting.find_by_name('global:disqus:shortname').destroy
  end
end
