require "rails_helper"

RSpec.describe RequestForm::LetterOfConsentCheck, type: :model do
  it { is_expected.to validate_presence_of(:letter_of_consent_check) }

  describe "validation" do
    subject(:form_object) { described_class.new(letter_of_consent_check: check) }

    let(:attachment) { create(:attachment) }
    let(:information_request) { build(:information_request, letter_of_consent_id: attachment.id) }

    before do
      form_object.request = information_request
    end

    context "when upload is correct" do
      let(:check) { "yes" }

      it "does not remove the attachment" do
        form_object.valid?
        expect(information_request.letter_of_consent_id).to eq attachment.id
      end

      it "does not change back value" do
        form_object.valid?
        expect(form_object.back).not_to be true
      end
    end

    context "when upload is incorrect" do
      let(:check) { "no" }

      it "removes the attachment" do
        form_object.valid?
        expect(information_request.letter_of_consent).to be_nil
      end

      it "changes back value" do
        form_object.valid?
        expect(form_object.back).to eq true
      end
    end
  end

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
      let(:information_request) { instance_double(InformationRequest, for_self?: false) }

      it "returns false" do
        expect(form_object).to be_required
      end
    end
  end
end
