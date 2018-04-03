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

########################################################################
#
########################################################################
class HomeRenderer < DcRenderer
  
########################################################################
# Render login/logout and loged in user
########################################################################
def login
  html = if @parent.session[:user_id].nil?
%Q[
  <span class="portal-login">
  #{@parent.link_to('Login:', '/login')}
  </span>
]
  else
%Q[
  <span class="portal-login">
  #{@parent.link_to('Odjava:', { controller: 'dc_common', action: 'logout', return_to: @parent.request.url} )}
  #{@parent.session[:user_name]}
  </span>
]
  end
  html
end

########################################################################
#
########################################################################
def default
  dashboard = Dashboard.new(@parent.session[:user_id], @parent.session[:user_roles]).render
  (dashboard.html + '<iframe id="iframe_edit" name="iframe_edit"></iframe>')
end

########################################################################
# Renderer dispatcher. Will skip access control for login renderer.
########################################################################
def render_html
  method = @opts[:method] || 'default'
  unless method == 'login'
    can_view, msg = @parent.dc_user_can_view(@parent, @parent.page)
    return msg unless can_view
  end
  respond_to?(method) ? send(method) : "#{self.class}: Method (#{method}) not defined!"
end


end