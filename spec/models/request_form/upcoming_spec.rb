require "rails_helper"

RSpec.describe RequestForm::Upcoming, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new }

    it { is_expected.to validate_presence_of(:upcoming_court_case) }

    describe "upcoming_court_case == 'yes'" do
      it "validates upcoming_court_case_text is present" do
        form_object.upcoming_court_case = "yes"
        expect(form_object).not_to be_valid
      end
    end
  end
end
