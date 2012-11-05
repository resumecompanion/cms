module Cms
  class ApplicationController < ActionController::Base
    def require_admin
      redirect_to cms.root_path unless cms_user_signed_in? && current_cms_user.is_admin?
    end
  end
end
