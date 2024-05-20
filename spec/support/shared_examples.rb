RSpec.shared_examples("question for everyone") do
  describe "#required?" do
    it { is_expected.to be_required }
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

RSpec.shared_examples("question when requesting prison data") do
  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when request is for prison service information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns false" do
        expect(form_object).to be_required
      end
    end

    context "when request is not for prison service information" do
      let(:information_request) { build(:information_request) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end
  end
end

RSpec.shared_examples("question when requesting probation data") do
  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when request is for probation service information" do
      let(:information_request) { build(:information_request_for_probation_service) }

      it "returns false" do
        expect(form_object).to be_required
      end
    end

    context "when request is not for probation service information" do
      let(:information_request) { build(:information_request) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end
  end
end

RSpec.shared_examples("question with standard saveable attributes") do
  subject(:form_object) { described_class.new }

  describe "#saveable_attributes" do
    it "matches attributes" do
      expect(form_object.saveable_attributes).to eq form_object.attributes
    end
  end
end
