source 'https://rubygems.org'

# Specify your gem's dependencies in rucomp.gemspec
gemspec

group :development, :test do
  gem 'pry', require: false
  gem 'pry-theme', require: false
  gem 'colorize', require: false
  gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec', require: false
  gem 'ruby_gntp', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end
