require "rails_helper"

RSpec.describe RequestForm::PrisonLocation, type: :model do
  it_behaves_like "question when requesting prison data"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new(request: information_request) }

    context "when for yourself" do
      let(:information_request) { build(:information_request_for_self) }

      it { is_expected.not_to validate_presence_of(:currently_in_prison) }
      it { is_expected.not_to validate_presence_of(:current_prison_name) }

      it "errors if recent_prison_name is missing" do
        form_object.valid?
        expect(form_object.errors.messages[:recent_prison_name].first).to include("Enter which prison you were most recently in")
      end
    end

    context "when for someone else" do
      let(:information_request) { build(:information_request_for_other) }

      it { is_expected.to validate_presence_of(:currently_in_prison) }

      context "when subject is currently in prison" do
        before do
          form_object.currently_in_prison = "yes"
        end

        it { is_expected.to validate_presence_of(:current_prison_name) }
      end

      context "when subject is not currently in prison" do
        before do
          form_object.currently_in_prison = "no"
        end

        it { is_expected.not_to validate_presence_of(:current_prison_name) }

        it "errors if recent_prison_name is missing" do
          form_object.valid?
          expect(form_object.errors.messages[:recent_prison_name].first).to include("Enter which prison they were most recently in")
        end
      end
    end
  end
end
