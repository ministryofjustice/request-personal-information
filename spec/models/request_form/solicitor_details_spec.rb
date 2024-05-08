require "rails_helper"

RSpec.describe RequestForm::SolicitorDetails, type: :model do
  it { is_expected.to validate_presence_of(:organisation_name) }

  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when subject is the requester" do
      let(:information_request) { instance_double(InformationRequest, for_self?: true) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end

    context "when subject is someone else" do
      context "when requester is a legal representative" do
        let(:information_request) { instance_double(InformationRequest, for_self?: false, solicitor_request?: true) }

        it "returns true" do
          expect(form_object).to be_required
        end
      end

      context "when requester is a relative" do
        let(:information_request) { instance_double(InformationRequest, for_self?: false, solicitor_request?: false) }

        it "returns true" do
          expect(form_object).not_to be_required
        end
      end
    end
  end
end
