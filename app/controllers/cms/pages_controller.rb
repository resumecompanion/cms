require 'cms/application_controller'
module Cms
  class PagesController < Cms::ApplicationController
    def index
      url = get_setting("global:index") || "/"
      redirect_to url, :status => 301
    end

    def show
      @home_path = get_setting("global:index")
      @page = Cms::Page.where(:slug => params[:id]).first

      if @page.blank? || (@page.is_published == false && @page.redirect_path.blank?)
        redirect_to get_setting('global:index'), status: :moved_permanently
        return
      end


      if @page.is_published == false && !@page.redirect_path.blank?
        redirect_to @page.redirect_path, :status => :moved_permanently
      else
        @page.increment_views_and_calculate_popularity
      end

      @title = @page.title || get_setting("global:meta_title")
      @meta_title = @page.meta_title
      @meta_description = @page.meta_description || get_setting("global:meta_description")
      @meta_keywords = @page.meta_keywords || get_setting("global:meta_keywords")
      @canonical_url = cms.pages_url(@page)
    end

    def search
    end

    def render_404
      render status: 404
    end
  end
end
