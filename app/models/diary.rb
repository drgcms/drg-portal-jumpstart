class Diary
 include Mongoid::Document
 include Mongoid::Timestamps

 field :title, type: String
 field :body, type: String
 field :time_begin, type: DateTime
 field :duration, type: Integer
 field :search, type: String
 
 field :user_id, type: BSON::ObjectId
 
 index user_id: 1
 
 validates :title, presence: true
 validates :time_begin, presence: true
 validates :duration, presence: true 
 
 before_save :fill_search_field
 
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

end