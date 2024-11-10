require "rails_helper"

RSpec.describe RequestForm::RequesterId, type: :model do
  it_behaves_like "question for friend or family of subject"
  it_behaves_like "file upload", :requester_photo

  describe "valid_file_type" do
    include ActionDispatch::TestProcess

    subject(:form_object) { described_class.new }

    let(:attachment_photo) { create(:attachment, key: "requester_photo") }
    let(:information_request) { build(:information_request, requester_photo_id: attachment_photo.id) }

    before do
      form_object.request = information_request
    end

    context "when file types are valid" do
      let!(:valid_photo_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/file.jpg"), "image/jpeg"), key: "requester_photo")
      end

      before do
        information_request.requester_photo_id = valid_photo_attachment.id
        form_object.request = information_request
      end

      it "is valid with a correct file type" do
        expect(form_object.request.requester_photo_id).to eq(valid_photo_attachment.id)
      end
    end
  end

  describe "invalid_file_type" do
    include ActionDispatch::TestProcess

    subject(:form_object) { described_class.new }

    let(:attachment_photo) { create(:attachment, key: "requester_photo") }
    let(:information_request) { build(:information_request, requester_photo_id: attachment_photo.id) }

    before do
      form_object.request = information_request
    end

    context "when file types are invalid" do
      let!(:invalid_photo_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_image.txt"), "plain/txt"), key: "requester_photo")
      end

      before do
        information_request.requester_photo_id = invalid_photo_attachment.id
        form_object.request = information_request
      end

      it "is invalid with a incorrect file type" do
        expect(form_object.request.requester_photo_id).to eq(invalid_photo_attachment.id)
      end
    end
  end
end
