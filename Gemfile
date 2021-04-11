source 'http://rubygems.org'
ENV['RAILS_ENV'] ||='development' 

gem 'rails', '~> 6.1'
gem 'activeresource'

gem 'sassc-rails'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'sprockets', '< 4'
gem 'uglifier'
gem 'non-stupid-digest-assets'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'font-awesome-rails'

gem 'bcrypt' #, '~> 3.0.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'mongoid' #, '= 7.1.0' # github: 'mongoid/mongoid'
gem 'mongo_session_store'
gem 'exception_notification'

# pagination
gem 'kaminari-mongoid'
gem 'kaminari-actionview'

gem 'rb-readline'                 # needed for rails c(onsole)
gem 'unicode_utils'

gem 'foundation-rails' #, '~> 6.3.0'

gem 'drg_cms', '~> 0.6'
gem 'drg_default_html_editor' #, '= 0.0.1'

gem 'bootsnap', require: false
gem 'spreadsheet'

if ENV['RAILS_ENV'] == 'development' or ENV["RAILS_ENV"] == "test"
  gem 'puma'
  gem 'byebug'
  gem 'web-console'
  gem 'listen'
  
  #gem 'drg_examples_gem'
#  gem 'my_own_gem', path: '../to_my_own_gem'
else #PRODUCTION
end

if ENV["RAILS_ENV"] == "development"
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  #gem "better_errors"
  #gem "binding_of_caller"  
end

if ENV["RAILS_ENV"] == "test"
  gem 'minitest'
  gem 'capybara'
  gem 'selenium-webdriver'
end
