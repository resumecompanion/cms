module Cms
  class Admin::CkeditorController < ::Cms::ApplicationController
    before_filter :require_admin
    layout nil

    def index
    end

    def create
    end
  end
end
