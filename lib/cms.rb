require 'devise'

require "cms/engine"
require 'cms/generators/install_generator'

module Cms
  def self.setup
    yield self
  end
end
