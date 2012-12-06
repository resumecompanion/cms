module Cms
  class PagesController < ApplicationController
    def index
      url = Cms::Setting.find_by_key("global:index")
      redirect_to url.value
    end

    def show
      @page = Cms::Page.where(:slug => params[:id], :is_published => true).first

      redirect_to :action => :render_404 if @page.blank?

      @title = @page.title || Cms::Setting.find_by_key("global:meta_title").try(:value)
      @meta_description = @page.meta_description || Cms::Setting.find_by_key("global:meta_description").try(:value)
      @meta_keywords = @page.meta_keywords || Cms::Setting.find_by_key("global:meta_keywords").try(:value)
    end

    def render_404
    end
  end
end
