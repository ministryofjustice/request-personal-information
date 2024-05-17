require "rails_helper"

RSpec.describe RequestForm::PrisonInformation, type: :model do
  it_behaves_like "question when requesting prison data"
  it_behaves_like "question with standard saveable attributes"

  describe "validations" do
    context "when no data type is selected" do
      subject { described_class.new }

      it { is_expected.to validate_presence_of(:prison_data) }
    end

    context "when prison_other_data is true" do
      subject { described_class.new(prison_other_data: "true") }

      it { is_expected.not_to validate_presence_of(:prison_data) }
      it { is_expected.to validate_presence_of(:prison_other_data_text) }
    end
  end
end
