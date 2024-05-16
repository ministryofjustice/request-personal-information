RSpec.shared_examples("validated attribute with custom message") do |attribute, valid_value|
  subject(:form_object) { described_class.new }

  let(:pronoun) { "your" }
  let(:information_request) { instance_double(InformationRequest, possessive_pronoun: pronoun) }

  before do
    form_object.request = information_request
  end

  describe "validation" do
    it "validates #{attribute} is present" do
      form_object.send("#{attribute}=", valid_value)
      expect(form_object).to be_valid
    end

    it "uses request pronoun in the error message" do
      form_object.valid?
      expect(form_object.errors.messages[attribute].first).to include("Enter #{pronoun} #{attribute.to_s.humanize.downcase}")
    end
  end
end

RSpec.shared_examples("file upload") do |attribute|
  describe "validation" do
    it { is_expected.to validate_presence_of(attribute) }

    context "when file is > 7MB" do
      subject(:form_object) { described_class.new }

      before do
        allow(File).to receive(:size).and_return(8.megabytes)
        form_object.send("#{attribute}=", fixture_file_upload("file.jpg"))
      end

      it "is not valid" do
        expect(form_object).not_to be_valid
      end

      it "is has the expected error message" do
        form_object.valid?
        expect(form_object.errors.messages[attribute].first).to eq "The selected file must be smaller than 7 MB"
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
  end
end
