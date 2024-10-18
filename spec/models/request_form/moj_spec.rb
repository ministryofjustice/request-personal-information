require "rails_helper"

RSpec.describe RequestForm::Moj, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validations" do
    subject(:form_object) { described_class.new }

    let(:information_request) { build(:information_request) }

    before do
      form_object.request = information_request
    end

    it { is_expected.to validate_presence_of(:moj) }

    context "when nothing is selected" do
      subject(:form_object) { described_class.new }

      it { is_expected.not_to be_valid }
    end

    context "when prison_service is true" do
      subject(:form_object) { described_class.new(prison_service: "true") }

      it { is_expected.to be_valid }
    end

    context "when probation_service is true" do
      subject(:form_object) { described_class.new(probation_service: "true") }

      it { is_expected.to be_valid }
    end

    context "when laa is true" do
      subject(:form_object) { described_class.new(laa: "true") }

      it { is_expected.to be_valid }
    end

    context "when opg is true" do
      subject(:form_object) { described_class.new(opg: "true") }

      it { is_expected.to be_valid }
    end
  end
end
