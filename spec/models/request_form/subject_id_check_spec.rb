require "rails_helper"

RSpec.describe RequestForm::SubjectIdCheck, type: :model do
  it_behaves_like "question when requester is not a solicitor"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new(subject_id_check: check) }

    let(:check) { "yes" }
    let(:attachment_photo) { create(:attachment, key: "subject_photo") }
    let(:attachment_address) { create(:attachment, key: "subject_proof_of_address") }
    let(:information_request) { build(:information_request, subject_photo_id: attachment_photo.id, subject_proof_of_address_id: attachment_address.id) }

    before do
      form_object.request = information_request
    end

    it { is_expected.to validate_presence_of(:subject_id_check) }

    context "when upload is correct" do
      let(:check) { "yes" }
      let(:attachment_photo) { create(:attachment, key: "subject_photo") }

      it "does not remove the attachment" do
        expect(information_request.subject_photo).to eq Attachment.find(attachment_photo.id)
        expect(information_request.subject_proof_of_address).to eq Attachment.find(attachment_address.id)
        form_object.valid?
      end

      it "does not change back value" do
        form_object.valid?
        expect(form_object.back).not_to be true
      end
    end

    describe "#valid_file_type" do
      include ActionDispatch::TestProcess

      context "when file types are valid" do
        let!(:valid_photo_attachment) do
          Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_image.jpg"), "image/jpeg"), key: "subject_photo")
        end

        let!(:valid_proof_attachment) do
          Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_image.jpg"), "image/jpeg"), key: "subject_proof_of_address")
        end

        before do
          information_request.subject_photo_id = valid_photo_attachment.id
          information_request.subject_proof_of_address_id = valid_proof_attachment.id
        end

        it "does not add an error for valid file types" do
          expect(information_request.errors[:subject_id_check]).to be_empty
        end
      end

      context "when file types are invalid" do
        let!(:invalid_photo_attachment) do
          Attachment.create(file: fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_image.txt"), "text/plain"), key: "subject_photo")
        end

        let!(:invalid_proof_attachment) do
          Attachment.create(
            file: fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_image.txt"), "plain/text"), key: "subject_proof_of_address",
          )
        end

        before do
          information_request.subject_photo_id = invalid_photo_attachment.id
          information_request.subject_proof_of_address_id = invalid_proof_attachment.id
        end

        it "adds an error for invalid file types" do
          form_object.valid?
          expect(form_object.errors[:subject_id_check]).to include("The selected file must be a PDF, image (jpg, .jpeg, .png) or Microsoft Word document (.doc, .docx)")
        end
      end
    end

    context "when upload is incorrect" do
      let(:check) { "no" }

      it "removes the attachment" do
        form_object.valid?
        expect(information_request.subject_photo_id).to be_nil
        expect(information_request.subject_proof_of_address_id).to be_nil
      end
    end
  end
end
