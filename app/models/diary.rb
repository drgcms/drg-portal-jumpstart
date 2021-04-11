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

class Diary
include Mongoid::Document
include Mongoid::Timestamps

field :title,       type: String
field :body,        type: String
field :time_begin,  type: Time
field :duration,    type: Integer
field :search,      type: String
field :closed,      type: Boolean, default: true
field :user_id,     type: BSON::ObjectId

index user_id: 1

validates :title,      presence: true
validates :time_begin, presence: true
validates :duration,   presence: true 

before_save :fill_search_field

after_save :cache_clear
after_destroy :cache_clear
 
#############################################################################
# Before save remove all html tags from body field and put data into search field.
#############################################################################
def fill_search_field
 text = ActionView::Base.full_sanitizer.sanitize(self.body, :tags=>[]).to_s
 text.gsub!(/\,|\.|\)|\(|\:|\;|\?/,'')
 text.gsub!('&#13;',' ')
 text.gsub!('&gt;',' ')
 text.gsub!('&lt;',' ')
 text.squish!
 
 self.search = (self.title + text).downcase
end

####################################################################
# Clear cache if cache is configured
####################################################################
def cache_clear
 DrgCms.cache_clear(:diary)
end


end