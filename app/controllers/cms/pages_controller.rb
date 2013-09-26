require 'cms/application_controller'
module Cms
  class PagesController < Cms::ApplicationController
    def index
      url = get_setting("global:index") || "/"
      redirect_to url, :status => 301
    end

    def show
      @page = Cms::Page.where(:slug => params[:id]).first

      if @page.blank? || (@page.is_published == false && @page.redirect_path.blank?)
        render 'render_404', status: :not_found
        return
      end


      if @page.is_published == false && !@page.redirect_path.blank?
        redirect_to @page.redirect_path, :status => :moved_permanently
      end

      @page.increment_views_and_calculate_popularity

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
