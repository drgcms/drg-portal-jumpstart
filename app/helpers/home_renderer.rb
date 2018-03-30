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
class DomaRenderer < DcRenderer

########################################################################
# Izpiše stanje za nadomeščanje
########################################################################
def stanje_nadomesca
  html = ''
  vodja_oddelkov = Sluzba.je_vodja?(@parent.session[:user_id])
  if zamenjava = Odsotnost.odsotnost_aktivna(@parent.session[:user_id], true)
    html << %Q[<div class='doma-opozorilo'>Aktivirano je nadomeščanje. 
             Trenutno vas nadomešča <b>#{dc_name4_id(DcUser,'name', nil, zamenjava.zamenja_id)}</b>.
             #{@parent.link_to("Izklopite nadomeščanje", 
             { controller: :cmsedit, action: :edit, id: zamenjava._id, 
             table: :odsotnost, form_name: 'odsotnost_preklic' }, target: :iframe_edit )}
             </div>]
  else
    html << "<div id='doma-prazno'>Odsotnost ni aktivna!       
    #{@parent.link_to 'Aktiviraj odsotnost', {controller: :cmsedit, table: :odsotnost, form_name: 'odsotnost_vpis', action: :new },target: :iframe_edit }</div>"
  end
  if namestnik_za = Odsotnost.zamenjava_za(@parent.session[:user_id]) 
    html << "<div id='doma-opozorilo'>Trenutno ste aktivni kot namestnik za:<b>"
    html << namestnik_za.inject('') {|r,e| r << dc_name4_id(DcUser,'name', nil, e) + ' ' }
    html << '</b>'
  end
# določi podpisnik za katere o  
  @podpisnik_za = namestnik_za || []
  @podpisnik_za << @parent.session[:user_id] if vodja_oddelkov
  html
end

########################################################################
# Ugotovi koliko nepotrjenih zahtevkov za spremembo ure je aktivnih. 
########################################################################
def stanje_urca
  return '' if @podpisnik_za.size == 0
  n = Urca.stevilo_odprtih_vpisov(@podpisnik_za)
#  
%Q[<div class="#{n == 0 ? 'doma-obvestilo' : 'doma-opozorilo'}">
  <span class="doma-stevilo">#{n} : </span>
  <span class="doma-text">Število nepotrjenih zahtevkov v evidenco ur.</span>
  #{n == 0 ? '' : @parent.link_to('Potrjevanje', { controller: 'cmsedit', table: 'urca', form_name: 'urca_potrdi',}, target: :iframe_edit )}
</div>]
end

########################################################################
#
########################################################################
def default
  dashboard = PortalDashboard.new(@parent.session[:user_id],@parent.session[:user_roles]).render
  dashboard.html + '<iframe id="iframe_edit" name="iframe_edit"></iframe>'
end

end
