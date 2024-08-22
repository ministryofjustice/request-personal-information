require "rails_helper"

RSpec.describe MailHelper, type: :helper do
  describe "#format_information" do
    let(:information_prison_probation) { "Prison Service<br>Probation Service" }
    let(:information_prison) { "Prison Service" }
    let(:information) { "" }

    it "returns an array of values when given a string" do
      result = helper.format_information(information_prison_probation)
      expect(result).to eq(["Prison Service", "Probation Service"])
    end

    it "returns string when no <br> tag" do
      result = helper.format_information(information_prison)
      expect(result).to eq(["Prison Service"])
    end

    it "returns an empty array when nothing selected" do
      result = helper.format_information(information)
      expect(result).to be_nil
    end
  end
end
