require "rails_helper"

RSpec.describe RequestForm::SubjectDateOfBirth, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new }

    context "when date is missing" do
      it "is invalid" do
        expect(form_object).to be_invalid
      end
    end

    context "when date is missing parts" do
      it "is invalid" do
        form_object.form_date_of_birth = { 3 => 1, 2 => 1, 1 => nil }
        expect(form_object).to be_invalid
      end
    end

    context "when date is has impossible data" do
      it "is invalid" do
        form_object.form_date_of_birth = { 3 => 943, 2 => 456, 1 => 2000 }
        expect(form_object).to be_invalid
      end
    end
  end
end
