require "rails_helper"

RSpec.describe RequestForm::LetterOfConsent, type: :model do
  it { is_expected.to validate_presence_of(:letter_of_consent) }

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