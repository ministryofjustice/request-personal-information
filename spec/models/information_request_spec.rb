require "rails_helper"

RSpec.describe InformationRequest, type: :model do
  describe "#possessive_pronoun" do
    context "when request subject is the requestor" do
      it "returns expected value" do
        request = described_class.new(subject: "self")
        expect(request.possessive_pronoun).to eq "your"
      end
    end

    context "when request subject is someone else" do
      it "returns expected value" do
        request = described_class.new(subject: "other")
        expect(request.possessive_pronoun).to eq "their"
      end
    end
  end

  describe "#to_hash" do
    it "contains all the attributes" do
      request = described_class.new(subject: "other", full_name: "full name", other_names: "other names")
      expect(request.to_hash).to include({ "subject": "other" })
      expect(request.to_hash).to include({ "full_name": "full name" })
      expect(request.to_hash).to include({ "other_names": "other names" })
    end
  end
end
