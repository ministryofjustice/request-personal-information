require "rails_helper"

RSpec.describe RequestForm::SubjectName, type: :model do
  subject(:form_object) { described_class.new }

  let(:information_request) { instance_double(InformationRequest, possessive_pronoun: "your") }

  before do
    form_object.request = information_request
  end

  describe "validation" do
    it "validates full_name is present" do
      form_object.full_name = "a name"
      expect(form_object).to be_valid
    end

    it "uses request pronoun in the error message" do
      form_object.valid?
      expect(form_object.errors.first.message).to include("Enter your full name")
    end
  end
end
