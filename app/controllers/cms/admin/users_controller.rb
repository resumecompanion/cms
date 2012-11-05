module Cms
  class Admin::UsersController < ::Cms::ApplicationController
    layout "cms/admin"

    before_filter :require_admin
    before_filter :find_user, :only => [:show, :edit, :update, :destroy]

    def index
      @users = Cms::User.all
    end

    def show
    end

    def new
      @user = Cms::User.new
    end

    def create
      @is_admin = String.new(params[:user][:is_admin])
      @user = Cms::User.new(params[:user], :without_protection => true)

      if @user.save
        redirect_to cms.admin_users_path
      else
        render :action => :new
      end
    end

    def edit
    end

    def update
      if @user.update_attributes(params[:user], :without_protection => true)
        redirect_to cms.admin_users_path
      else
        render :action => :edit
      end
    end

    def destroy
      #TODO we should move the page which was created by @user
      @user.destroy
      redirect_to cms.admin_users_path
    end

    protected

    def find_user
      @user = Cms::User.find(params[:id])
    end
  end
end
