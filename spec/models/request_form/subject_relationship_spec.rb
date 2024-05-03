require "rails_helper"

RSpec.describe RequestForm::SubjectRelationship, type: :model do
  it { is_expected.to validate_presence_of(:relationship) }

  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when subject is the requestor" do
      let(:information_request) { instance_double(InformationRequest, for_self?: true) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end

    context "when subject is someone else" do
      let(:information_request) { instance_double(InformationRequest, for_self?: false) }

      it "returns true" do
        expect(form_object).to be_required
      end
    end
  end
end
