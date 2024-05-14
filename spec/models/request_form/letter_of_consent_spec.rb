require "rails_helper"

RSpec.describe RequestForm::LetterOfConsent, type: :model do
  it_behaves_like "file upload with max filesize validation", :letter_of_consent
  it_behaves_like "question when requester is not the subject"

  describe "validation" do
    context "when file was previously uploaded" do
      subject(:form_object) { described_class.new(letter_of_consent_id: upload.id) }

      let(:upload) { create(:attachment) }

      it "is valid" do
        expect(form_object).to be_valid
      end
    end
  end

  describe "#saveable_attributes" do
    subject(:form_object) { described_class.new }

    it "does not include letter_of_consent_id" do
      expect(form_object.saveable_attributes.keys).not_to include "letter_of_consent_id"
    end

    context "when letter_of_consent is nil" do
      it "does not include letter_of_consent" do
        expect(form_object.saveable_attributes.keys).not_to include "letter_of_consent"
      end
    end

    context "when letter_of_consent is present" do
      it "includes letter_of_consent" do
        form_object.letter_of_consent = "exists"
        expect(form_object.saveable_attributes.keys).to include "letter_of_consent"
      end
    end
  end
end
