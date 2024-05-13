require "rails_helper"

RSpec.describe RequestForm::RequesterIdCheck, type: :model do
  it { is_expected.to validate_presence_of(:requester_id_check) }

  describe "validation" do
    subject(:form_object) { described_class.new(requester_id_check: check) }

    let(:attachment_photo) { create(:attachment, key: "requester_photo") }
    let(:attachment_address) { create(:attachment, key: "requester_proof_of_address") }
    let(:information_request) { build(:information_request, requester_photo_id: attachment_photo.id, requester_proof_of_address_id: attachment_address.id) }

    before do
      form_object.request = information_request
    end

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
      let(:information_request) { build(:information_request_for_self) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end

    context "when subject is someone else" do
      context "when requester is a legal representative" do
        let(:information_request) { build(:information_request_by_solicitor) }

        it "returns true" do
          expect(form_object).not_to be_required
        end
      end

      context "when requester is a relative" do
        let(:information_request) { build(:information_request_by_friend) }

        it "returns true" do
          expect(form_object).to be_required
        end
      end
    end
  end
end
