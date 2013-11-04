module Cms
  class ApplicationController < ActionController::Base
    before_filter :get_ga_account
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
  end
end
