#########################################################################
#
#########################################################################
def ok_to_start
#  DcPermission.all.delete
#  DcPolicyRole.all.delete
#  DcUser.all.delete
  if DcPermission.all.to_a.size > 0
    p 'DcPermission (Permissions) collection is not empty! Aborting.'
    return false
  end
  if DcPolicyRole.all.to_a.size > 0
    p 'DcUserRole (User roles) collection is not empty! Aborting.'
    return false
  end
  if DcUser.all.to_a.size > 0
    p 'DcUser (Users) collection is not empty! Aborting.'
    return false
  end
  true
end

#########################################################################
#
#########################################################################
def read_input(message, default='')
  p "#{message} "
  response = STDIN.gets.chomp
  response.blank? ? default : response
 end

########################################################################
#
########################################################################
def create_superadmin
  begin
    username = read_input('Enter username for superadmin role:')
    p 'Username should be at least 6 character long' if username.size < 6
  end while username.size < 6
  begin
    password = read_input("Enter password for #{username} user :")
    p 'Password should be at least 8 character long' if password.size < 8
  end while password.size < 8
# Guest role first
  role = DcPolicyRole.new
  role.name = 'guest'
  role.system_name = 'guest'
  role.save
# Superadmin role
  sa = DcPolicyRole.new
  sa.name = 'superadmin'
  sa.system_name = 'superadmin'
  sa.save
# Superadmin user
  usr = DcUser.new
  usr.username    = username
  usr.password    = password
  usr.password_confirmation = password
  usr.first_name  = 'superadmin'
  usr.save
# user role 
  user_role = DcUserRole.new
  user_role.dc_policy_role_id = sa._id
  usr.dc_user_roles << user_role
# cmsedit permission
  permission = DcPermission.new
  permission.table_name = 'Default permission'
  permission.is_default = true
  permission.save
# 
  r = DcPolicyRule.new
  r.dc_policy_role_id = sa._id
  r.permission = DcPermission::SUPERADMIN
  permission.dc_policy_rules << r
# create login poll
  poll = DcPoll.new
  poll.name = 'login'
  poll.display = 'td'
  poll.operation = 'link'
  poll.parameters = '/dc_common/process_login'
  poll.title = 'Autocreated login form'
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
#
  p "Superadmin user created. Remember login data #{username}/#{password}"
end 

########################################################################
# Initial database seed
########################################################################
def seed
  if ARGV.last == '-clear'
    DcSite.all.delete
    DcSimpleMenu.all.delete
    DcPage.all.delete
  end
  
  if DcSite.all.size > 0
    p 'DcSite (Sites) collection is not empty! Aborting.'
    return 
  end

  if (sa = DcPolicyRole.find_by(system_name: 'superadmin')).nil?
    p 'superadmin role not defined! Aborting.'
    return 
  end

  if (guest = DcPolicyRole.find_by(system_name: 'guest')).nil?
    p 'guest role not defined! Aborting.'
    return 
  end
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
  rule = DcPolicyRule.new( dc_policy_role_id: sa.id, permission: DcPermission::CAN_EDIT)
  policy.dc_policy_rules << rule
  rule = DcPolicyRule.new( dc_policy_role_id: guest.id, permission: DcPermission::NO_ACCESS)
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

  item = DcMenuItem.new(caption: 'Diary', link: 'diary', order: 20)
  item.page_id = page.id
  menu.dc_menu_items << item
  page.menu_id = "#{menu.id};#{item.id}"
  page.save

  # Page and menu for ToDo
  page = DcPage.new(
    subject: 'ToDo',
    subject_link: 'todo',
    dc_design_id: design._id,
    dc_site_id: site.id,
    publish_date: Time.now
  )
  page.save

  item = DcMenuItem.new(caption: 'ToDo', link: 'todo', order: 30)
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

  item = DcMenuItem.new(caption: 'Blank', link: 'blank', order: 200)
  item.page_id = page.id
  menu.dc_menu_items << item
  page.menu_id = "#{menu.id};#{item.id}"
  page.save
  p 'Seed data created succesfully.'
end

#########################################################################
#
#########################################################################
namespace :portal do
  desc "At the beginning god created superadmin"
  task :at_the_beginning => :environment do
    if ok_to_start
      create_superadmin
    end
  end

  desc "Seed initial data"
  task :seed => :environment do
    seed
  end

end