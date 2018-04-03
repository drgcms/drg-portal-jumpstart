#--
# Copyright (c) 
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

#######################################################################
# 
# InitController is used for creating administrator user and for creating 
# initial portal data.
# 
# Please remove this file after initial usage.
# 
#######################################################################
class InitController < ApplicationController
before_action :check_database

def check_database
  flash[:error] = ''
  if DcSite.all.size > 0
    flash[:error] << 'DcSite (Sites) collection is not empty!<br>'
  end
  if DcPermission.all.size > 0
    flash[:error] << 'DcPermission (Permissions) collection is not empty!<br>'
  end
  if DcPolicyRole.all.size > 0
    flash[:error] <<'DcUserRole (User roles) collection is not empty!<br>'
  end
  if DcUser.all.size > 0
    flash[:error] << 'DcUser (Users) collection is not empty!<br>'
  end 
end

#######################################################################
#
#######################################################################
def index
end

#######################################################################
#
#######################################################################
def create
  return render :index if flash[:error].size > 0
  if params[:superuser].size < 6 
    flash[:error] << 'Username should be at least 6 characters long!<br>'
  end
  
  if params[:password].size < 8 
    flash[:error] << 'Password size should be at least 8 characters long!<br>'
  end
  
  if params[:password] != params[:password1]
    flash[:error] << 'Passwords do not match!<br>'
  end
  return render :index if flash[:error].size > 0
  
  seed_admin 
  seed_data
end

########################################################################
#
########################################################################
def seed_admin
# Guest role first
  @guest = DcPolicyRole.new
  @guest.name = 'guest'
  @guest.system_name = 'guest'
  @guest.save
# Superadmin role
  @sa = DcPolicyRole.new
  @sa.name = 'superadmin'
  @sa.system_name = 'superadmin'
  @sa.save
# Superadmin user
  usr = DcUser.new
  usr.username    = params[:superuser]
  usr.password    = params[:password]
  usr.password_confirmation = params[:password]
  usr.first_name  = 'superadmin'
  usr.save
# user role 
  user_role = DcUserRole.new
  user_role.dc_policy_role_id = @sa.id
  usr.dc_user_roles << user_role
# cmsedit permission
  permission = DcPermission.new
  permission.table_name = 'Default permission'
  permission.is_default = true
  permission.save
# 
  r = DcPolicyRule.new
  r.dc_policy_role_id = @sa.id
  r.permission = DcPermission::SUPERADMIN
  permission.dc_policy_rules << r
# create login poll
  poll = DcPoll.new
  poll.name = 'login'
  poll.display = 'td'
  poll.operation = 'link'
  poll.parameters = '/portal/process_login'
  poll.title = 'Internal portal login'
  poll.save
#
  i = poll.dc_poll_items.new
  i.name = 'username'
  i.size = 15
  i.text = 'Username'
  i.type = 'text_field'
  i.save
#  
  i = poll.dc_poll_items.new
  i.name = 'password'
  i.size = 15
  i.text = 'Password'
  i.type = 'password_field'
  i.save
#
  i = poll.dc_poll_items.new
  i.name = 'send'
  i.text = 'Login'
  i.type = 'submit_tag'
  i.save
end 

#######################################################################
#
#######################################################################
def seed_data
  # Test site document points to real site document
  site = DcSite.new(
    name: 'test',
    alias_for: 'portal.mysite.com')
  site.save
# Site document
  site = DcSite.new(
    name: 'portal.mysite.com',
    homepage_link: "home",
    menu_class: "DcMenu",
    menu_name: "portal-menu",
    page_class: "DcPage",
    page_table: "dc_page",
    files_directory: "files",    
    settings: "ckeditor:\n config_file: /files/ck_config.js\n css_file: /files/ck_css.css\n",
    site_layout: "content")
  site.save
# Default site policy
  policy = DcPolicy.new(
    description: "Default policy",
    is_default: true,
    message: "Access denied. You shold be logged in for this operation.",
    name: "Default policy")
  site.dc_policies << policy
# Policy rules. Administrator can edit guest can view
  rule = DcPolicyRule.new( dc_policy_role_id: @sa.id, permission: DcPermission::CAN_EDIT)
  policy.dc_policy_rules << rule
  rule = DcPolicyRule.new( dc_policy_role_id: @guest.id, permission: DcPermission::NO_ACCESS)
  policy.dc_policy_rules << rule
# Design document  
  design = DcDesign.new(description: 'Default portal design')
  design.rails_view = 'designs/portal'
  design.save
# Page document
  page = DcPage.new(
    subject: 'Home page',
    subject_link: 'home',
    dc_design_id: design.id,
    dc_site_id: site.id,
    publish_date: Time.now,
  )
  page.save
# Menu
  menu = DcMenu.new(
    name: "portal-menu",
    description: "Internal portal menu",
    dc_site_id: site.id
    )
  menu.save
# update menu_id in site  
  site.menu_id = menu.id
  site.save
# Items
  item = DcMenuItem.new(caption: 'Home', link: 'home', order: 10)
  item.page_id = page.id
  menu.dc_menu_items << item
# This menu item will be selected when page is displayed  
  page.menu_id = "#{menu.id};#{item.id}"
  page.save

# Page and menu for Diary
  page = DcPage.new(
    subject: 'Diary',
    subject_link: 'diary',
    dc_design_id: design._id,
    dc_site_id: site.id,
    publish_date: Time.now
  )
  page.save
# 
  item = DcMenuItem.new(caption: 'Diary', link: 'diary', order: 20)
  item.page_id = page.id
  menu.dc_menu_items << item
  page.menu_id = "#{menu.id};#{item.id}"
  page.save

# Additional empty page
  page = DcPage.new(
    subject: 'Blank',
    subject_link: 'blank',
    dc_design_id: design.id,
    dc_site_id: site.id,
    publish_date: Time.now
  )
  page.save
# 
  item = DcMenuItem.new(caption: 'Blank', link: 'blank', order: 30)
  item.page_id = page.id
  menu.dc_menu_items << item
  page.menu_id = "#{menu.id};#{item.id}"
  page.save
  
end

end
