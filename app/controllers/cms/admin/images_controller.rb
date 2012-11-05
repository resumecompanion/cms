module Cms
  class Admin::ImagesController < ::Cms::ApplicationController
    layout "cms/admin"
    before_filter :require_admin
    before_filter :find_file, :only => [:show, :edit, :update, :destroy]

    def index
      @files = Cms::File.order("id DESC")
    end

    def show
    end

    def new
      @file = Cms::File.new
    end

    def create
      @file = Cms::File.new(params[:file])
      @file.user = current_cms_user
      if @file.save
        redirect_to cms.admin_images_path
      else
        render :action => :new
      end
    end

    def edit
    end

    def update
      if @file.update_attributes(params[:file])
        redirect_to cms.admin_images_path
      else
        render :action => :edit
      end
    end

    def destroy
      @file.destroy
      redirect_to cms.admin_images_path
    end

    protected

    def find_file
      @file = Cms::File.find(params[:id])
    end
  end
end
