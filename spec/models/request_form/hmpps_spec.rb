require "rails_helper"

RSpec.describe RequestForm::Hmpps, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validations" do
    it { is_expected.to validate_presence_of(:hmpps_information) }
    it { is_expected.not_to validate_presence_of(:hmpps) }

    context "when hmpps_information == yes" do
      subject { described_class.new(hmpps_information: "yes") }

      it { is_expected.to validate_presence_of(:hmpps) }

      context "when prison_service and probation_service are false" do
        subject { described_class.new(hmpps_information: "yes") }

        it { is_expected.not_to be_valid }
      end

      context "when prison_service is true" do
        subject { described_class.new(hmpps_information: "yes", prison_service: "true") }

        it { is_expected.to be_valid }
      end

      context "when probation_service is true" do
        subject { described_class.new(hmpps_information: "yes", probation_service: "true") }

        it { is_expected.to be_valid }
      end
    end
  end
end
