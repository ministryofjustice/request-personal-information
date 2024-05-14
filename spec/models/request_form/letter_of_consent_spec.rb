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
end
