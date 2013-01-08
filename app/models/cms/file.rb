module Cms
  class File < ActiveRecord::Base
    attr_accessible :image, :title, :filename

    mount_uploader :image, Cms::ImageUploader
    paginates_per 48

    validates_presence_of :image

    belongs_to :user, :foreign_key => :cms_user_id

    def filename=(filename)
      self.image.rename(filename) if filename.present?
    end

    def filename
      ::File.basename(self.image.path).split(".").first
    end
  end
end
