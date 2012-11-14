module Cms
  module ApplicationHelper
    def render_cms_page_title(title)
     title = Cms::Setting.find_by_key("global:meta_title").value rescue "" if title.blank?
     content_tag("title", title)
    end

    def render_cms_meta_description(meta_description)
      meta_description = Cms::Setting.find_by_key("global:meta_description").value rescue "" if meta_description.blank?
      tag(:meta, {:name => "description", :content => meta_description})
    end

    def render_cms_meta_keywords(meta_keywords)
      meta_keywords = Cms::Setting.find_by_key("global:meta_keywords").value rescue "" if meta_keywords.blank?
      tag(:meta, {:name => "keywords", :content => meta_keywords})
    end
  end
end
