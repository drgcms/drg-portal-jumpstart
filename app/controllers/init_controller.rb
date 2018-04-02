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
def save
  return render :index if flash[:error].size > 0
  if params[:username].size < 6 
    flash[:error] << 'Username should be at least 6 characters long!'
  end
  
  if params[:password].size < 8 
    flash[:error] << 'Password size should be at least 8 characters long!'
  end
  
  if params[:password] != params[:password1]
    flash[:error] << 'Entered passwords do not match!'
  end
  return render :index if flash[:error].size > 0

  
end

end
