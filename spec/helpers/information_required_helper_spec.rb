
require 'rails_helper'

RSpec.describe InformationRequiredHelper, type: :helper do
  describe '#format_information' do
    let(:information) {"Prison Service<br>Probation Service" }

    it 'returns an array of values when given a string' do
      result = helper.format_information(information)
      expect(result).to eq(["Prison Service", "Probation Service"])
    end
  end
end
