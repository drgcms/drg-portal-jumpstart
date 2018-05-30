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

class ReportsController < DcCommonController
  
##########################################################################
# Will create diary report into excel file end download file to user.
##########################################################################
def diary()
  date_from = DrgcmsFormFields::DatePicker.get_data( params, 'date_from' ).beginning_of_day
  date_to   = DrgcmsFormFields::DatePicker.get_data( params, 'date_to' ).end_of_day
  name      = DcUser.find(session[:user_id]).name
  format_14      = Spreadsheet::Format.new :weight => :bold, :size => 14
  format_10      = Spreadsheet::Format.new :size => 10
  format_10_bold = Spreadsheet::Format.new :weight => :bold, :size => 10
  
  book  = Spreadsheet::Workbook.new
  page = book.create_worksheet :name => 'Diary'
  page.default_format = format_10
# 
  page[0,0] = "#{name}: DIARY #{date_from.strftime('%d.%m.%Y')} - #{date_to.strftime('%d.%m.%Y')}"
  page.row(0).default_format = format_14
  row, col = 2, -1
  ['Date','Time(min)','Title'].each { |glava| page[row, (col+=1)] = glava }
  page.row(2).default_format = format_10_bold
#
  row = 3
  Diary.where(user_id: session[:user_id], 
          :time_begin.gte => date_from, :time_begin.lte => date_to)
         .order_by(time_begin: 1).each do |document|
    page[row,0] = document.time_begin.to_date
    page[row,1] = document.duration
    page[row,2] = document.title
    row += 1
  end
  tmp = "report.xls" # or even better temporary name
  book.write Rails.root.join('public',tmp)
  render json: { :window_report => "/#{tmp}" }
end

end
