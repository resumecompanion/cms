require 'devise'
require 'simple_form'
require 'compass-rails'

require "cms/engine"
require 'cms/generators/install_generator'

module Cms
  def self.setup
    yield self
  end
end
