module Cms
  class ApplicationController < ActionController::Base
    before_filter :get_ga_account
    before_filter :prepend_view_path_for_theme
    helper_method :global_index

    def require_admin
      redirect_to cms.root_path unless cms_user_signed_in? && current_cms_user.is_admin?
    end

    def get_setting(key)
      Cms::Setting.find_by_key(key).try(:value)
    end

    def get_ga_account
      @ga_account = get_setting("global:ga_account")
    end

    def global_index
      get_setting("global:index")
    end

    def global_theme
      @theme ||= get_setting("global:theme")
    end


    protected
    def prepend_view_path_for_theme
      prepend_view_path "#{Cms::Engine.root}/app/views/#{global_theme}"
    end

    def set_layout
      "cms/#{global_theme}"
    end
  end
end
