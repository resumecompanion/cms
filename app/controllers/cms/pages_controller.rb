module Cms
  class PagesController < ApplicationController
    def index
      url = get_setting("global:index") || "/"
      redirect_to url, :status => 301
    end

    def show
      @page = Cms::Page.where(:slug => params[:id], :is_published => true).first

      redirect_to :action => :render_404 if @page.blank?

      @title = @page.title || get_setting("global:meta_title")
      @meta_description = @page.meta_description || get_setting("global:meta_description")
      @meta_keywords = @page.meta_keywords || get_setting("global:meta_keywords")
    end

    def render_404
    end
  end
end
