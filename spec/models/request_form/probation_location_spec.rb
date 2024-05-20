require "rails_helper"

RSpec.describe RequestForm::ProbationLocation, type: :model do
  it_behaves_like "question when requesting probation data"
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new }

    let(:possessive_pronoun) { "their" }
    let(:information_request) { instance_double(InformationRequest, possessive_pronoun:) }

    before do
      form_object.request = information_request
    end

    describe "probation_office" do
      context "when missing" do
        it "is not valid" do
          expect(form_object).not_to be_valid
        end

        it "uses request pronoun in the error message" do
          form_object.valid?
          expect(form_object.errors.messages[:probation_office].first).to include("Enter their probation office or approved premises")
        end
      end

      context "when provided" do
        it "is valid" do
          form_object.probation_office = "probation location"
          expect(form_object).to be_valid
        end
      end
    end
  end
end
