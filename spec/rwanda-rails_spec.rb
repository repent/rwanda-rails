require 'spec_helper'

describe Rwanda do
  describe Rails do
    describe 'rwanda-location' do
      it 'does weird shit' do
        expect(Rwanda.instance.rwanda-location).to eq 'WEIRD SHIT, YO'
      end
    end
  end
end