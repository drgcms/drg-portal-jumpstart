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

class Dashboard 
include DcApplicationHelper  
include ActionView::Helpers::UrlHelper

attr_reader :html, :js, :footer

########################################################################
# Initialize dashboard element
########################################################################
def initialize(user, user_roles=nil) 
# parameters send as DcUser object or just as id
  if user.class == DcUser
    @user       = user
    @user_id    = user.id
    @user_roles = user.dc_user_roles.inject([]) {|r,v| r << v.dc_policy_role_id}
  else
    @user_id    = user
    @user       = DcUser.find(@user_id)
    @user_roles = user_roles
  end
# 
  @server  = case
    when Rails.env == 'production' then 'http://portal.mysite.com'
    when Rails.env == 'stage' then 'http://stage.portal.mysite.com'
    else 'http://localhost:3000'
  end  
  @html, @js = ''
  @msgs      = {}
  self  
end

########################################################################
# Adds one dashboard elemnt to array of elements
########################################################################
def dashboard_element(type, title, text='')
  @msgs[type] ||= ''  
  @msgs[type] << <<EOT
  <div class="dashboard-#{type}">
    <div id="title">#{title}</div>
    #{('<div id="text">' + text + '</div>') if text.size > 0}
  </div>
EOT
end

########################################################################
# Just writes out current user name
########################################################################
def dash_001_who_am_i
  dashboard_element(:info, 'WHO AM I', "Hello #{@user.name}. Information text example.") 
end

########################################################################
# Inform user that has some unfinished bussines in diary.
########################################################################
def dash_010_diary_status
  count = Diary.where(user_id: @user_id, closed: false).count
  if count > 0
    text  = "#{link_to('Click', @server + '/diary')}, to review." 
    dashboard_element(:warning, "#{count} UNCLOSED documents in DIARY", text) 
  end
end

########################################################################
# Just some warning
########################################################################
def dash_020_a_warning
  dashboard_element(:warning, 'SOME WARNING', 'Warning text. Nothing comes to mind.')
end

########################################################################
# Simulating error dashboard element
########################################################################
def dash_030_error
  if @user.username == 'rems'
    dashboard_element(:info, 'HELLO MR. REMS', '')
  else
    dashboard_element(:error, 'YOU ARE NOT MR. REMS', 'This is error text example.')
  end    
end

########################################################################
# Collect all methods starting with _dash, sort them and execute them in order.
# Thats how result order can be predictable and reused if needed resulting in 
# faster dashboard creation. 
########################################################################
def render()
  dash_methods = methods.delete_if {|method| !method.to_s.start_with?('dash_')}
  dash_methods.sort.each { |method| send(method) }
# Create output
  [:error,:warning,:info].each {|type| @html << "<div class=\"dashboard-panel\">#{@msgs[type]}</div>" }
  @html << '<div style="clear: both;"></div>'
  self
end

end 

