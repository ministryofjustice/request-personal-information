require "rails_helper"

RSpec.describe RequestForm::ProbationInformation, type: :model do
  it_behaves_like "question when requesting probation data"
  it_behaves_like "question with standard saveable attributes"

  describe "validations" do
    context "when no data type is selected" do
      subject { described_class.new }

      it { is_expected.to validate_presence_of(:probation_data) }
    end

    context "when probation_other_data is true" do
      subject { described_class.new(probation_other_data: "true") }

      it { is_expected.not_to validate_presence_of(:probation_data) }
      it { is_expected.to validate_presence_of(:probation_other_data_text) }
    end
  end
end
