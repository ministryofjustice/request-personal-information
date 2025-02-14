require "rails_helper"

RSpec.describe RequestForm::SubjectId, type: :model do
  it_behaves_like "question when requester is not a solicitor"
  it_behaves_like "file upload", :subject_photo

  describe "valid_file_type" do
    include ActionDispatch::TestProcess

    subject(:form_object) { described_class.new }

    let(:attachment_photo) { create(:attachment, key: "subject_photo") }
    let(:information_request) { build(:information_request, subject_photo_id: attachment_photo.id) }

    before do
      form_object.request = information_request
    end

    context "when file types are valid" do
      let!(:valid_photo_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/file.jpg"), "image/jpeg"), key: "subject_photo")
      end

      before do
        information_request.subject_photo_id = valid_photo_attachment.id
        form_object.request = information_request
      end

      it "is valid with a correct file type" do
        expect(form_object.request.subject_photo_id).to eq(valid_photo_attachment.id)
      end
    end
  end

  describe "invalid_file_type" do
    include ActionDispatch::TestProcess

    subject(:form_object) { described_class.new }

    let(:attachment_photo) { create(:attachment, key: "subject_photo") }
    let(:information_request) { build(:information_request, subject_photo_id: attachment_photo.id) }

    before do
      form_object.request = information_request
    end

    context "when file types are invalid" do
      let!(:invalid_photo_attachment) do
        Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_image.txt"), "plain/txt"), key: "subject_photo")
      end

      before do
        information_request.subject_photo_id = invalid_photo_attachment.id
        form_object.request = information_request
      end

      it "is invalid with a incorrect file type" do
        expect(form_object.request.subject_photo_id).to eq(invalid_photo_attachment.id)
      end
    end
  end
end
