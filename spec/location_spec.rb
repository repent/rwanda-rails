require 'spec_helper'

#describe Rwanda do
describe Location do

  #binding.pry

  district = Location.new 'Karongi'
  sector = Location.new 'Karongi','Bwishyura'
  cell = Location.new 'Karongi','Bwishyura','Kiniha'
  village = Location.new 'Karongi','Bwishyura','Kiniha','Nyarurembo'
  none = Location.new
  invalid = Location.new 'Karongi', 'Kiniha', 'Bwishyura', 'Nyarurembo'
  
  describe 'to_s' do
    it 'can output a location in human-readable form' do
      expect(village.to_html).to eq '<b>Karongi</b> District, <b>Bwishyura</b> Sector, <b>Kiniha</b> Cell, <b>Nyarurembo</b> Village'.html_safe
      expect(sector.to_html).to eq '<b>Karongi</b> District, <b>Bwishyura</b> Sector'
      expect(Location.new.to_s).to eq 'Unknown'
    end
  end
end
#end