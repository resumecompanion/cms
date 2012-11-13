$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cms"
  s.version     = Cms::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Cms."
  s.description = "TODO: Description of Cms."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "jquery-rails"
  s.add_dependency "devise"
  s.add_dependency "simple_form"
  s.add_dependency "carrierwave"
  s.add_dependency "rmagick"
  s.add_dependency "sass-rails", '~> 3.2.0'
  s.add_dependency "compass-rails"
  s.add_dependency "stringex"
  s.add_dependency "kaminari"
end
