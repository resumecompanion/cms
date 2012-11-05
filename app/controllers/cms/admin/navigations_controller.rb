module Cms
  class Admin::NavigationsController < ::Cms::ApplicationController
    layout "cms/admin"

    before_filter :require_admin
    before_filter :find_navigation, :only => [:edit, :update, :destroy]

    def index
      @navigations = Cms::Navigation.order("position")
    end

    def new
      @navigation = Cms::Navigation.new
      @navigation.position = Cms::Navigation.all.size + 1
    end

    def create
      @navigation = Cms::Navigation.new(params[:navigation])
      if @navigation.save
        redirect_to cms.admin_navigations_path
      else
        render :action => :new
      end
    end

    def edit
    end

    def update
      if @navigation.update_attributes(params[:navigation])
        redirect_to cms.admin_navigations_path
      else
        render :action => :edit
      end
    end

    def destroy
      @navigation.destroy
      redirect_to cms.admin_navigations_path
    end

    protected

    def find_navigation
      @navigation = Cms::Navigation.find(params[:id])
    end
  end
end
