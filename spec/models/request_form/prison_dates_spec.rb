require "rails_helper"

RSpec.describe RequestForm::PrisonDates, type: :model do
  it_behaves_like "question when requesting prison data"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    context "when invalid date assigned for form_prison_date_from" do
      subject(:form_object) { described_class.new }

      it "is invalid" do
        form_object.form_prison_date_from = { 3 => 1, 2 => 1, 1 => nil }
        expect(form_object).to be_invalid
      end
    end

    context "when invalid date assigned for prison_date_to" do
      subject(:form_object) { described_class.new }

      it "is invalid" do
        form_object.form_prison_date_to = { 3 => 1, 2 => 1, 1 => nil }
        expect(form_object).to be_invalid
      end
    end
  end
end
