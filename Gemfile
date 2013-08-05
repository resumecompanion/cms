source "http://rubygems.org"

# Declare your gem's dependencies in cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'jquery-rails'
gem 'devise'
gem 'simple_form'
gem 'carrierwave'
gem 'fog'
gem 'stringex'
gem 'kaminari'
gem 'thinking-sphinx', :require => "thinking_sphinx"


gem 'mysql2'

group :assets do
  gem 'sass-rails',   '~> 3.2.0'
  gem 'compass-rails'
end


gem "rspec-rails"
group :test, :cucumber do
  gem 'spork', '~> 1.0.0rc3'
  gem 'fuubar'
  gem 'factory_girl_rails'
  gem 'rmagick', '2.12.2'
end

group :development do
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
