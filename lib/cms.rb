require 'devise'
require 'simple_form'
require 'compass-rails'
require 'carrierwave'
require 'stringex'
require 'kaminari'
require 'compass'

require 'cms/engine'
require 'cms/generators/install_generator'

module Cms
  def self.setup
    yield self
  end
end
