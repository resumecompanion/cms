module Cms
  module Admin
    class PagesController < ::Cms::ApplicationController
      layout "cms/admin"

      before_filter :require_admin
      before_filter :find_page, :only => [:edit, :update, :destroy]

      def index
        if params[:q].present?
          @pages = Cms::Page.search(:conditions => {:title => params[:q]}).page(params[:page])
        else
          @pages = Cms::Page.where(:parent_id => nil).includes(:author)
          @last_update_page = Cms::Page.find(params[:last_update_id]) if params[:last_update_id].present?
        end
      end

      def new
        @page = Cms::Page.new
        @users = Cms::User.where(:is_admin => true)
        @roots = Cms::Page.where(:parent_id => nil)
      end

      def create
        @page = Cms::Page.new(params[:page])
        if @page.save
          redirect_to cms.admin_pages_path(:last_update_id => @page.id)
        else
          @users = Cms::User.where(:is_admin => true)
          @roots = Cms::Page.where(:parent_id => nil)
          render :action => :new
        end
      end

      def edit
        @users = Cms::User.where(:is_admin => true)
        @roots = Cms::Page.where("parent_id IS NULL and id !=?", @page.id)
        @parent_ids = @page.all_parent_ids
      end

      def update
        if @page.update_attributes(params[:page])
          redirect_to cms.admin_pages_path(:last_update_id => @page.id)
        else
          @parent_ids = @page.all_parent_ids
          @users = Cms::User.where(:is_admin => true)
          @roots = Cms::Page.where("parent_id IS NULL and id !=?", @page.id)
          render :action => :edit
        end
      end

      def destroy
        @page.destroy
        redirect_to cms.admin_pages_path
      end

      def children
        @children = Cms::Page.where(:parent_id => params[:id]).includes(:author)
        render :layout => false
      end

      def children_selector
        @children = Cms::Page.where(:parent_id => params[:id])
        render :layout => false
      end

      protected

      def find_page
        @page = Cms::Page.find_by_slug(params[:id])
      end
    end
  end
end
