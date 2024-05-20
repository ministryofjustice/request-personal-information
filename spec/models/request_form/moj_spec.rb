require "rails_helper"

RSpec.describe RequestForm::Moj, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validations" do
    subject { described_class.new }

    it { is_expected.to validate_presence_of(:moj) }

    context "when nothing is selected" do
      subject { described_class.new }

      it { is_expected.not_to be_valid }
    end

    context "when laa is true" do
      subject { described_class.new(laa: "true") }

      it { is_expected.to be_valid }
    end

    context "when opg is true" do
      subject { described_class.new(opg: "true") }

      it { is_expected.to be_valid }
    end

    context "when moj_other is true" do
      subject { described_class.new(moj_other: "true", "moj_other_text": "other text") }

      it { is_expected.not_to validate_presence_of(:moj) }
      it { is_expected.to validate_presence_of(:moj_other_text) }
    end
  end
end
