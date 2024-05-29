require "rails_helper"

RSpec.describe RequestForm::ContactEmail, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    it "validates the email address format" do
      form_object = described_class.new(contact_email: "invalid")
      expect(form_object).not_to be_valid
    end
  end
end
