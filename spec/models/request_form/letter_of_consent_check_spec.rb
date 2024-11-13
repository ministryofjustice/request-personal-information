require "rails_helper"

RSpec.describe RequestForm::LetterOfConsentCheck, type: :model do
  it_behaves_like "question when requester is not the subject"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new(letter_of_consent_check: check) }

    let(:check) { "yes" }
    let(:attachment) { create(:attachment) }
    let(:information_request) { build(:information_request, letter_of_consent_id: attachment.id) }

    before do
      form_object.request = information_request
    end

    it { is_expected.to validate_presence_of(:letter_of_consent_check) }

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
        expect(form_object.back).to be 1
      end
    end
  end
end
