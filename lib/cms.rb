require 'devise'
require 'simple_form'
# require 'compass-rails'
require 'carrierwave'
require 'fog'
require 'stringex'
require 'kaminari'
require 'compass'
require 'thinking_sphinx'

require 'cms/engine'
require 'cms/generators/install_generator'
require 'cms/generators/add_meta_title_generator'

module Cms
  def self.setup
    yield self
  end
end
