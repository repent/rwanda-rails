require 'spec_helper'
require 'action_view'

describe Rwanda do
  #describe Rails do
    describe 'rwanda_location' do
      it 'provides an interface to input a Rwandan location' do
        person = {}
        form_for(person) do |f|
          expect(f.rwanda_location).to eq 'DROPDOWN OUTPUT'
        end
      end
    end
  #end
end