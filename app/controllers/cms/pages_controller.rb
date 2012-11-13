module Cms
  class PagesController < ApplicationController
    def index
    end

    def show
      @page = Cms::Page.where(:slug => params[:id], :is_published => true).first
    end
  end
end
