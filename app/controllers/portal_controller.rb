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

class PortalController < DcCommonController
  
before_action :dc_reload_patches if Rails.env.development?

##########################################################################
# Will determine design content or view filename which defines design.
# 
# Returns:
#  design_body: design body as defined in site or design document.
#  design_view: view file name which will be used for rendering design
##########################################################################
def get_design_and_render(design_doc)
  layout      = @site.site_layout.blank? ? 'content' : @site.site_layout
  site_top    = '<%= dc_page_top %>'
  site_bottom = '<%= dc_page_bottom %>'
# design defined in design doc 
  if design_doc
    if !design_doc.rails_view.blank? 
      if design_doc.rails_view.downcase != 'site'
        return render design_doc.rails_view, layout: layout
      end
    elsif !design_doc.body.blank?
      design = site_top + design_doc.body + site_bottom
      return render(inline: design, layout: layout)
    end
  end
# design defined in site
  if @site.rails_view.blank? 
    design = site_top + @site.design + site_bottom
    return render(inline: design, layout: layout)
  end
  render @site.rails_view, layout: layout
end

###########################################################################
# Default portal page request processing.
# 
# This is small change of dc_process_default_request found in dc_main_controller.
###########################################################################
def page()
  session[:edit_mode] ||= 0
# Initialize parts
  @parts    = nil
  @js, @css = '', ''
# find domain name in sites
  @site = dc_get_site
# site is not defined. render 404 error
  return dc_render_404('Site!') if @site.nil?
  dc_set_options(@site.settings)
# HOMEPAGE. When no parameters is set
  params[:path] = @site.homepage_link if params[:id].nil? and params[:path].nil?
# Search for page 
  pageclass = @site.page_table.classify.constantize
  if params[:id]
    @page = pageclass.find_by(subject_link: params[:id])
  elsif params[:path]
# path may point direct to page's subject_link
    @page = pageclass.find_by(subject_link: params[:path])
  end
# if @page is not found render 404 error
  return dc_render_404('Page!') unless @page
  dc_set_options @page.params
# find design if defined. Otherwise design MUST be declared in site
  if @page.dc_design_id
    @design = DcDesign.find(@page.dc_design_id)
    return dc_render_404('Design!') unless @design
  end
# Add to edit menu
  if session[:edit_mode] > 0
    session[:site_id]         = @site.id
    session[:site_page_table] = @site.page_table
    session[:page_id]         = @page.id
  end
# perform check every hour. Perhaps if user has rights changes
  session[:last_check] ||= Time.now
  if (session[:last_check] - Time.now) > 3600
    # perform checks
    # TO BE DONE
    
    # update time
    session[:last_check] = Time.now
  end  
  @page_title = @page.subject.empty? ? @site.page_title : @page.subject
  get_design_and_render @design
end

####################################################################
# Process login with an option to authenticate to LDAP server.
####################################################################
def process_login
# Something is really wrong
  return dc_render_404('Login:') unless ( params[:record] and params[:record][:username] and params[:record][:password] )
  success = false
  unless params[:record][:password].blank? 
# user must be defined locally
    user = DcUser.find_by(username: params[:record][:username])
    if user
# LDAP alternative. You must add gem 'net-ldap' to Gemfile    
#      ldap = Net::LDAP.new(host: 'ldap.yourdomain.com')
#      ldap.auth("#{params[:record][:username]}@yourdomain.com", params[:record][:password])
#      success = ldap.bind

# authenticate locally
      success = user.authenticate(params[:record][:password]) unless success
    end
  end
# 
  if success
    fill_login_data(user, false)
    redirect_to '/'
  else # display login error
    flash[:error] = t('drgcms.invalid_username')
    redirect_to "/login"
  end
end

end
