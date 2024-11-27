require "rails_helper"

RSpec.describe RequestForm::RequesterAddress, type: :model do
  it_behaves_like "question for friend or family of subject"
  it_behaves_like "file upload", :requester_proof_of_address

  describe "validation" do
    include ActionDispatch::TestProcess

    subject(:form_object) { described_class.new }

    let(:attachment_address) { create(:attachment, key: "requester_proof_of_address") }
    let(:information_request) { build(:information_request, requester_proof_of_address_id: attachment_address.id) }

    before do
      form_object.request = information_request
    end

    context "when file types are valid" do
      let!(:valid_proof_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/file.jpg"), "image/jpeg"), key: "requester_proof_of_address")
      end

      before do
        information_request.requester_proof_of_address_id = valid_proof_attachment.id
        form_object.request = information_request
      end

      it "is valid with a correct file type" do
        expect(form_object.request.requester_proof_of_address_id).to eq(valid_proof_attachment.id)
      end
    end

    context "when file types are invalid" do
      let!(:invalid_proof_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_image.txt"), "plain/txt"), key: "requester_proof_of_address")
      end

      before do
        information_request.requester_proof_of_address_id = invalid_proof_attachment.id
        form_object.request = information_request
      end

      it "is invalid with an incorrect file type" do
        expect(form_object.request.requester_proof_of_address_id).to eq(invalid_proof_attachment.id)
      end
    end
  end
end
