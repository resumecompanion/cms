module Cms
  class Page < ActiveRecord::Base
    attr_accessible :parent_id, :author_id, :sidebar_id, :position, :title, :is_displayed_title, :slug, :meta_description, :meta_keywords,
                    :content, :is_published, :generate_slug, :meta_title, :redirect_path

    attr_accessor :generate_slug

    has_many :children, :class_name => "Cms::Page", :foreign_key => :parent_id, :dependent => :destroy
    belongs_to :parent, :class_name => "Cms::Page", :foreign_key => :parent_id

    belongs_to :author, :class_name => "Cms::User", :foreign_key => :author_id
    belongs_to :sidebar, :class_name => "Cms::Sidebar", :foreign_key => :sidebar_id

    validates_presence_of :author_id, :title

    before_create :handle_slug

    before_save :set_meta_title
    after_create :update_parent_child_count
    after_update :update_parent_child_count
    after_destroy :update_parent_child_count

    scope :five_most_popular, lambda {
      home_page = Cms::Setting.find_by_key("global:index").try(:value)
      if home_page.nil?
        where({}).limit(5).order("popularity DESC")
      else
        slug = home_page.split('/').last.to_url
        where("slug != ?", slug).limit(5).order("popularity DESC")
      end
    }

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

    def increment_views_and_calculate_popularity
      self.views = self.views + 1
      self.popularity = self.views.to_f / days_since_creation.to_f
      self.save
      self
    end

    def days_since_creation
      return 1 if created_at.nil?
      days= (Time.now - created_at).to_i / (60 * 60 * 24)
      days == 0 ? 1 : days
    end

    def level
      all_parent_ids.length + 1
    end

    def first_image_url
      doc = Nokogiri::HTML(self.content)
      doc.css('img').first.nil? ? "" : doc.css('img').first.attr(:src)
    end

    def images_sitemap
      ha = []
      doc = Nokogiri::HTML(self.content)
      doc.css('img').each do |img|
        ha << {:loc => img.attr(:src), :title => (img.attr(:title) || img.attr(:alt) || '')}
      end
      ha
    end


    def is_template_page?
      self.all_parent_ids.include? 1
    end
    
    def sample_of_children(excluded_child)
      self.children.where("id != ? and is_published = ?", excluded_child.id, true).sample(5)
    end


    def update_child_count
      update_attribute :children_count, children.where("is_published = ?", true).count unless nil?
    end

    def update_parent_child_count
      parent.update_child_count unless parent.nil?
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

    def set_meta_title
      self.meta_title = self.title if self.meta_title.blank?
    end
  end
end


