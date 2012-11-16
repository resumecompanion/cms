module Cms
  module Admin
    class SidebarsController < ::Cms::ApplicationController
      layout "cms/admin"

      before_filter :require_admin
      before_filter :find_sidebar, :only => [:show, :edit, :update]

      def index
        @sidebars = Cms::Sidebar.all
      end

      def new
        @sidebar = Cms::Sidebar.new
      end

      def create
        @sidebar = Cms::Sidebar.new(params[:sidebar])
        if @sidebar.save
          redirect_to cms.admin_sidebars_path
        else
          render :action => :new
        end
      end

      def edit
      end

      def update
        if @sidebar.update_attributes(params[:sidebar])
          redirect_to cms.admin_sidebars_path
        else
          render :action => :edit
        end
      end

      protected

      def find_sidebar
        @sidebar = Cms::Sidebar.find(params[:id])
      end
    end
  end
end
