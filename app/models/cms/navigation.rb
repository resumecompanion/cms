module Cms
  class Navigation < ActiveRecord::Base
    attr_accessible :name, :link, :link_title, :position, :is_hidden, :append_position
    attr_accessor :append_position

    validates :name, :link, :link_title, :presence => true

    before_save :set_position
    after_destroy :update_position

    protected

    def set_position
      if self.append_position.present?
        self.position = append_position.to_i + 1

        elements = self.class.where("position > ?", self.append_position)
        elements.each do |element|
          element.update_attributes(:position => element.position + 1)
        end
      end
    end

    def update_position
      elements = self.class.order("position ASC")
      elements.each_with_index do |element, i|
        element.update_attributes(:position => i + 1)
      end
    end
  end
end