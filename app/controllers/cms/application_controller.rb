module Cms
  class ApplicationController < ActionController::Base
    def require_admin
      redirect_to cms.root_path unless cms_user_signed_in? && current_cms_user.is_admin?
    end

    def get_setting(key)
      Cms::Setting.find_by_key(key).try(:value)
    end
  end
end
