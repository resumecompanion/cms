module Cms
  class PagesController < ApplicationController
    def index
      url = Cms::Setting.find_by_key("global:index") || "/"
      redirect_to url.value
    end

    def show
      @page = Cms::Page.where(:slug => params[:id], :is_published => true).first

      redirect_to :action => :render_404 if @page.blank?
    end

    def render_404
    end
  end
end
