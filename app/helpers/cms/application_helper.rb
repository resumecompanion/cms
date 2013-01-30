module Cms
  module ApplicationHelper
    def render_cms_page_title(title)
     content_tag("title", title)
    end

    def render_cms_meta_description(meta_description)
      tag(:meta, {:name => "description", :content => meta_description})
    end

    def render_cms_meta_keywords(meta_keywords)
      tag(:meta, {:name => "keywords", :content => meta_keywords})
    end

    def render_canonical_url(url)
      tag(:link, :rel => :canonical, :href => @canonical_url) if url
    end

    def navigation_selected?(navigation, page)
      if page.parent.present?
        parent_page = Page.find(page.all_parent_ids.first)
        return "selected" if cms.pages_path(parent_page) == navigation.link
      else
        return "selected" if cms.pages_path(@page) == navigation.link
      end

      return ""
    end
  end
end
