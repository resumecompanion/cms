module Cms
  module Admin
    class CkeditorController < ::Cms::ApplicationController
      before_filter :require_admin
      layout "cms/simple"

      def index
        @files = Cms::File.page(params[:page]).order("id DESC")
      end

      def create
        @file = Cms::File.new
        @file.image = params[:upload]
        @file.cms_user_id = params[:user_id]
        @file.save
      end
    end
  end
end
