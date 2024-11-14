require "rails_helper"

RSpec.describe RequestForm::RequesterIdCheck, type: :model do
  it_behaves_like "question for friend or family of subject"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new(requester_id_check: check) }

    let(:check) { "yes" }
    let(:attachment_photo) { create(:attachment, key: "requester_photo") }
    let(:attachment_address) { create(:attachment, key: "requester_proof_of_address") }
    let(:information_request) { build(:information_request, requester_photo_id: attachment_photo.id, requester_proof_of_address_id: attachment_address.id) }

    before do
      form_object.request = information_request
    end

    it { is_expected.to validate_presence_of(:requester_id_check) }

    context "when upload is correct" do
      let(:check) { "yes" }

      it "does not remove the attachment" do
        form_object.valid?
        expect(information_request.requester_photo_id).to eq attachment_photo.id
        expect(information_request.requester_proof_of_address_id).to eq attachment_address.id
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
        expect(information_request.requester_photo_id).to be_nil
        expect(information_request.requester_proof_of_address_id).to be_nil
      end

      it "changes back value" do
        form_object.valid?
        
        expect(form_object.back).to eq 2
      end
    end
  end
end
