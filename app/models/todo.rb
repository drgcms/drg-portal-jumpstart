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

###########################################################################
# Simple TODO application
###########################################################################
class Todo
include Mongoid::Document
include Mongoid::Timestamps

belongs_to :dc_user

field :subject,     type: String
field :body,        type: String
field :time,        type: Time
field :priority,    type: Integer, default: 1
field :closed,      type: Boolean, default: false
field :time_closed, type: Time
field :created_by,  type: BSON::ObjectId

index dc_user_id: 1

validates :subject, presence: true

before_save :do_before_save

###########################################################################
# update time_closed when closed selected
###########################################################################
def do_before_save
  self.time_closed = Time.now if closed_changed? && closed
end

###########################################################################
# Returns state of todo request and closed date if request is closed
###########################################################################
def closed_state
  icon = closed ? 'check-square-o' : 'square-o'
  date = closed ? CmsCommonHelper.dc_format_date_time(time_closed, 'd') : ''
  %(<i class="fa fa-#{icon} fa-lg"></i> &nbsp;#{date})
end


########################################################################
# Return filter options
########################################################################
def self.dc_filters
  { 'title' => 'texts.todo.filter_hide_closed', 'operation' => 'eq',
    'field' => 'closed', 'value' => false }
end

end
