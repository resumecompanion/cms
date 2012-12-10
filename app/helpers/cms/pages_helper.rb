module Cms
  module PagesHelper
    def convert_macro(content)
      doc = Nokogiri::HTML.fragment(content)

      # ex: <children_count>home</children_count>
      doc.css("children_count").each do |dom|
        page = Cms::Page.select(:children_count).where(:slug => dom.content).first
        dom.name = "span"
        dom.content = "(#{page.children_count rescue 0})"
      end

      # ex: <children_pages>home</children_pages>
      doc.css("children_pages").each do |dom|
        page = Cms::Page.where(:slug => dom.content).first
        dom.name = "div"
        page.children.order("title").each do |child_page|
          dom << link_to(child_page.title, cms.pages_path(child_page))
        end
      end

      doc.inner_html
    end
  end
end
