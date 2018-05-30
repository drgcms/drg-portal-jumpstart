source 'http://rubygems.org'
ENV['RAILS_ENV'] ||='development' 

gem 'rails', '~> 5.2.0'
gem 'activeresource'

gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'uglifier'      #, '>= 1.0.3'
gem 'non-stupid-digest-assets'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'font-awesome-rails'

gem 'bcrypt' #, '~> 3.0.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'mongoid' #, '= 6.3.0' # github: 'mongoid/mongoid'
gem 'mongo_session_store-rails5'
gem 'exception_notification'

# pagination
gem 'kaminari-mongoid'
gem 'kaminari-actionview'

gem 'rb-readline'                 # needed for rails c(onsole)
gem 'unicode_utils'

gem 'foundation-rails' #, '~> 6.3.0'

gem 'drg_cms' #, '= 0.0.7'
gem 'drg_default_html_editor' #, '= 0.0.1'

gem 'bootsnap', require: false
gem 'spreadsheet'

if ENV['RAILS_ENV'] == 'development' #DEVELOPMENT
  gem 'puma'
  gem 'listen'

  gem 'spring'
  gem 'spring-watcher-listen' #, '~> 2.0.0'
  
#  gem 'my_own_gem', path: '../to_my_own_gem'
else #PRODUCTION
end
