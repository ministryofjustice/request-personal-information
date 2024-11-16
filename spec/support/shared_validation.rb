RSpec.shared_examples("file upload") do |attribute|
  describe "validation" do
    it { is_expected.to validate_presence_of(attribute) }

    context "when file is > 7MB" do
      subject(:form_object) { described_class.new }

      let(:upload) { create(:attachment) }

      before do
        allow(File).to receive(:size).and_return(8.megabytes)
        form_object.send("#{attribute}_id=", upload.id)
        form_object.send("#{attribute}=", fixture_file_upload("file.jpg", "image/jpeg"))
      end

      it "is not valid" do
        expect(form_object).not_to be_valid
      end

      it "is has the expected error message" do
        form_object.valid?
        expect(form_object.errors.messages[attribute].first).to eq "The selected file must be 7 MB or smaller"
      end
    end

    describe "#allowed_types" do
      subject(:form_object) { described_class.new }

      let(:upload) { create(:attachment) }

      before do
        allow(File).to receive(:size).and_return(6.megabytes)
        form_object.send("#{attribute}_id=", upload.id)
        form_object.send("#{attribute}=", fixture_file_upload("invalid_image.txt", "plain/txt"))
      end

      it "is not valid" do
        expect(form_object).not_to be_valid
      end

      it "is has the expected error message" do
        form_object.valid?
        expect(form_object.errors.messages[attribute].first).to eq ("The selected file must be a PDF, image (jpg, .jpeg, .png) or Microsoft Word document (.doc, .docx)")
      end
    end

    context "when file was previously uploaded" do
      subject(:form_object) { described_class.new }

      let(:upload) { create(:attachment) }

      before do
        form_object.send("#{attribute}_id=", upload.id)
      end

      it "is valid" do
        expect(form_object.errors.messages[attribute]).to be_empty
      end
    end

    describe "#saveable_attributes" do
      subject(:form_object) { described_class.new }

      context "when file was previously uploaded" do
        it "includes the upload id only" do
          form_object.send("#{attribute}_id=", 1)
          expect(form_object.saveable_attributes.keys).to include "#{attribute}_id"
          expect(form_object.saveable_attributes.keys).not_to include attribute.to_s
        end
      end

      context "when there is no upload" do
        it "does not include any upload attribute" do
          expect(form_object.saveable_attributes.keys).not_to include attribute.to_s
          expect(form_object.saveable_attributes.keys).not_to include "#{attribute}_id"
        end
      end

      context "when file is being uploaded" do
        it "includes file, but no ID" do
          form_object.send("#{attribute}=", "exists")
          form_object.send("#{attribute}_id=", 1)
          expect(form_object.saveable_attributes.keys).to include attribute.to_s
          expect(form_object.saveable_attributes.keys).not_to include "#{attribute}_id"
        end
      end


    end

    describe "#updateable_attributes" do
      subject(:form_object) { described_class.new }

      it "excludes file objects" do
        expect(form_object.updateable_attributes.keys).not_to include attribute.to_s
      end
    end
  end
end
