module Cms
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :description
  end
end
