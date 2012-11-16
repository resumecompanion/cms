module Cms
  module Admin
    class NavigationsController < ::Cms::ApplicationController
      layout "cms/admin"

      before_filter :require_admin
      before_filter :find_navigation, :only => [:edit, :update, :destroy]

      def index
        @navigations = Cms::Navigation.order("position ASC")
      end

      def new
        @navigation = Cms::Navigation.new(:position => Cms::Navigation.all.size + 1)
        @navigations = Cms::Navigation.order("position ASC")
      end

      def create
        @navigation = Cms::Navigation.new(params[:navigation])
        if @navigation.save
          redirect_to cms.admin_navigations_path
        else
          @navigations = Cms::Navigation.order("position ASC")
          render :action => :new
        end
      end

      def edit
        @navigations = Cms::Navigation.where("id != ?", @navigation.id).order("position ASC")
      end

      def update
        if @navigation.update_attributes(params[:navigation])
          redirect_to cms.admin_navigations_path
        else
          @navigations = Cms::Navigation.where("id != ?", @navigation.id).order("position ASC")
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
end
