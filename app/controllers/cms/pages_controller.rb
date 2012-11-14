module Cms
  class PagesController < ApplicationController
    def index
      url = Cms::Setting.find_by_key("global:index") || "/"
      redirect_to url.value
    end

    def show
      @page = Cms::Page.where(:slug => params[:id], :is_published => true).first
    end
  end
end
