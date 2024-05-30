require "rails_helper"

RSpec.describe RequestForm::PrisonNumber, type: :model do
  it_behaves_like "question when requesting prison data"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new(request: information_request) }

    context "when for yourself" do
      let(:information_request) { build(:information_request_for_self) }

      it { is_expected.not_to validate_presence_of(:prison_number) }
    end

    context "when for someone else" do
      let(:information_request) { build(:information_request_for_other) }

      it { is_expected.to validate_presence_of(:prison_number) }
    end
  end
end
