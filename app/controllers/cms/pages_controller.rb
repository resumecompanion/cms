module Cms
  class PagesController < ApplicationController
    def index
    end

    def show
      @page = Cms::Page.find_by_slug(params[:id])
    end
  end
end
