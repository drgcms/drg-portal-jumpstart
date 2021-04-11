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

######################################################################
# Controls file for Todo application
######################################################################
module TodoControl

###########################################################################
# Allow only current user documents to be displayed
###########################################################################
def my_todo_documents_filter
  order = user_sort_options(Todo)
  order ||= { time_begin: -1 }
  user_filter_options(Todo).and(dc_user_id: session[:user_id]).order_by(order)
end

###########################################################################
# Close todo task
###########################################################################
def close_task
  doc = Todo.find(params[:id])
  doc.closed = !doc.closed
  doc.save
  render json: { window: 'reload' }
end

###########################################################################
# Is close todo task button active
###########################################################################
def self.close_button_active(parent)
  !parent.record.closed
end

end
