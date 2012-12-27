module Cms
  class Page < ActiveRecord::Base
    attr_accessible :parent_id, :author_id, :sidebar_id, :position, :title, :is_displayed_title, :slug, :meta_description, :meta_keywords,
                    :content, :is_published, :generate_slug, :meta_title

    attr_accessor :generate_slug

    has_many :children, :class_name => "Cms::Page", :foreign_key => :parent_id, :dependent => :destroy
    belongs_to :parent, :class_name => "Cms::Page", :foreign_key => :parent_id

    belongs_to :author, :class_name => "Cms::User", :foreign_key => :author_id
    belongs_to :sidebar, :class_name => "Cms::Sidebar", :foreign_key => :sidebar_id

    validates_presence_of :author_id, :title

    before_create :handle_slug

    before_create :increase_counter
    before_update :update_counter
    before_destroy :decrease_counter

    define_index do
      indexes title, :as => :title
      indexes content, :as => :content
    end

    def to_param
      self.slug
    end

    def all_parent_ids
      parent_ids_array = []
      last_term_page = self
      temp_page = self.class.select("id, parent_id").where(:id => last_term_page.parent_id).first

      while(temp_page.present?)
        parent_ids_array << temp_page.id
        last_term_page = temp_page
        temp_page = self.class.select("id, parent_id").where(:id => last_term_page.parent_id).first
      end

      parent_ids_array.reverse
    end

    def images_sitemap
      ha = []
      doc = Nokogiri::HTML(self.content)
      doc.css('img').each do |img|
        ha << {:loc => img.attr(:src), :title => (img.attr(:title) || img.attr(:alt) || '')}
      end
      ha
    end

    protected

    def handle_slug
      if generate_slug != false
        self.slug = title.to_url
        if self.slug.present?
          same_pages_count = self.class.where(:slug => slug).size
          self.slug = "#{self.slug}-#{same_pages_count}" if same_pages_count > 0
        else
          self.errors.add(:title, "can't generate slug")
          return false
        end
      end
    end

    def increase_counter
      self.class.increment_counter(:children_count, self.parent_id) if self.parent_id.present?
    end

    def update_counter
      if self.parent_id_changed?
        self.class.decrement_counter(:children_count, self.parent_id_was) if self.parent_id_was.present?
        self.class.increment_counter(:children_count, self.parent_id) if self.parent_id_was.present?
      end
    end

    def decrease_counter
      self.class.decrement_counter(:children_count, self.parent_id) if self.parent_id.present?
    end
  end
end


