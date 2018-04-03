require "fileutils"
require "shellwords"

#########################################################################
# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
#########################################################################
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("jumpstart-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/drg-cms/drg-jumpstart.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{jumpstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

#########################################################################
# Reads data from terminal input
#########################################################################
def read_input(message, default='')
  message.split("\n").each {|e| print "#{e} " }
  response = STDIN.gets.chomp
  response.blank? ? default : response
end

#########################################################################
#
#########################################################################
def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

#########################################################################
#
#########################################################################
def copy_templates
  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true
end

#def add_webpack
#  rails_command 'webpacker:install'
#end

#########################################################################
#
#########################################################################
def update_routes
  insert_into_file "config/routes.rb",
%Q[
  root :to => 'portal#page'
  DrgCms.routes

  put '/portal/process_login' => 'portal#process_login'
  resources :init # remove after initial run
  get '*path' => 'portal#page'

],
  after: "Rails.application.routes.draw do"
end

#########################################################################
#
#########################################################################
def update_initializers
# assets.rb  
  append_to_file "config/initializers/assets.rb", 
    "Rails.application.config.assets.precompile += %w( cms.css cms.js)"  
end

#########################################################################
# 
#########################################################################
def add_stage
# duplicate production.rb  
  begin
  copy_file '../' + File.join(@app_path,"config/environments/production.rb"),
            '../' + File.join(@app_path,"config/environments/stage.rb"), force: true
  rescue Exception
    p 'Error creating stage.rb file. If you are going to use staging environment just copy config/environments/production.rb to stage.rb!'
  end
end

#########################################################################
#
#########################################################################
def update_application
# action cable is not required  
  gsub_file "config/application.rb",
    /require \"action_cable\/engine\"/,
    '## require "action_cable/engine"'
  
# add default forms path
  append_to_file "config/application.rb", "DrgCms.add_forms_path Rails.root.join('app/forms')"
end

#########################################################################
#
#########################################################################
def update_mongoid_setup
# update database names  
  gsub_file "config/mongoid.yml", /drgcms_/, "#{@app_name}_"
end

#########################################################################
#
#########################################################################
def copy_gemfile
  copy_file "Gemfile", force: true 
end

#########################################################################
#
#########################################################################
def copy_bundler_setup
  directory ".bundle", force: true
end

#########################################################################
#
#########################################################################
def update_gitignore
  append_to_file ".gitignore", 
%Q[
#added by DRG
/nbproject/
.gitignore
/vendor/ruby
]
end

#########################################################################
#########################################################################

# Main setup
add_template_repository_to_source_path

copy_templates
copy_bundler_setup
copy_gemfile
#
update_gitignore
update_mongoid_setup
update_application
update_initializers
add_stage
#
after_bundle do
  set_application_name
  update_routes
  
  begin
    git :init
    git add: "."
    git commit: %Q{ -m 'Initial commit' --quiet }
    p 'Git initial commit created.'
  rescue Exception
    p 'Error creating Git repository!'
  end
end
