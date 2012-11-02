module Cms
  class Navigation < ActiveRecord::Base
    attr_accessible :name, :link, :link_title, :position, :is_hidden

    validates :name, :link, :link_title, :presence => true
  end
end