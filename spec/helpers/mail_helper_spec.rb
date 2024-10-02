require "rails_helper"

RSpec.describe MailHelper, type: :helper do
  describe "#split_list" do
    let(:information_prison_probation) { "Prison service<br>Probation service" }
    let(:information_prison) { "Prison service" }
    let(:information_prison_number) { nil }

    it "returns an array of values when given a string" do
      result = helper.split_list(information_prison_probation)
      expect(result).to eq(["Prison service", "Probation service"])
    end

    it "returns string when no <br> tag" do
      result = helper.split_list(information_prison)
      expect(result).to eq(["Prison service"])
    end

    it "returns an empty array when prison number is an empty string" do
      result = helper.split_list("")
      expect(result).to eq([])
    end
  end
end
