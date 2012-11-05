module Cms
  class File < ActiveRecord::Base
    attr_accessible :image, :title

    mount_uploader :image, Cms::ImageUploader

    validates_presence_of :image

    belongs_to :user, :foreign_key => :cms_user_id
  end
end
