module Cms
  class Admin::SettingsController < ::Cms::ApplicationController
    layout "cms/admin"

    before_filter :require_admin

    def index
      @settings = Cms::Setting.all
    end

    def edit
      @setting = Cms::Setting.find(params[:id])
    end

    def update
      @setting = Cms::Setting.find(params[:id])
      if @setting.update_attributes(params[:setting])
        redirect_to cms.admin_settings_path
      else
        render :action => :edit
      end
    end
  end
end
