require 'devise'
require 'simple_form'
require 'compass-rails'
require 'carrierwave'
require 'rmagick'
require 'stringex'
require 'kaminari'

require "cms/engine"
require 'cms/generators/install_generator'

module Cms
  def self.setup
    yield self
  end
end
