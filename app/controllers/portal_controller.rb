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
# lets try the rails way
 if @options[:control] and @options[:action]
    controller = "#{@options[:control]}_control".classify.constantize rescue nil
    extend controller if controller
    return send @options[:action] if respond_to?(@options[:action])
  end
#  
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
# 
  if @site.rails_view.blank? 
    design = site_top + @site.design + site_bottom
    return render(inline: design, layout: layout)
  end
  render @site.rails_view, layout: layout
end

###########################################################################
# Default request processing.
# 
# Za portal je potrebna manjša predelava
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
  dc_set_is_mobile unless session[:is_mobile] # do it only once per session
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
    # update time
    session[:last_check] = Time.now
  end  
  @page_title = @page.subject.empty? ? @site.page_title : @page.subject
  get_design_and_render @design
end

end
