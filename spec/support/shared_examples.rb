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

RSpec.shared_examples("file upload with max filesize validation") do |attribute|
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
  end
end

RSpec.shared_examples("question when requester is not the subject") do
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
      let(:information_request) { build(:information_request_for_other) }

      it "returns false" do
        expect(form_object).to be_required
      end
    end
  end
end

RSpec.shared_examples("question for solicitor") do
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
          expect(form_object).to be_required
        end
      end

      context "when requester is a relative" do
        let(:information_request) { build(:information_request_by_friend) }

        it "returns true" do
          expect(form_object).not_to be_required
        end
      end
    end
  end
end

RSpec.shared_examples("question for friend or family of subject") do
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

RSpec.shared_examples("question when requester is not a solicitor") do
  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when subject is the requester" do
      let(:information_request) { build(:information_request_for_self) }

      it "returns false" do
        expect(form_object).to be_required
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
