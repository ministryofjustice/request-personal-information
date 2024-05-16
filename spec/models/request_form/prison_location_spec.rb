require "rails_helper"

RSpec.describe RequestForm::PrisonLocation, type: :model do
  it_behaves_like "question with standard saveable attributes"

  describe "validation" do
    subject(:form_object) { described_class.new }

    let(:pronoun) { "they" }
    let(:information_request) { instance_double(InformationRequest, pronoun:) }

    before do
      form_object.request = information_request
    end

    describe "currently_in_prison" do
      it "validates currently_in_prison is present" do
        form_object.currently_in_prison = "no"
        expect(form_object).not_to be_valid
      end

      it "uses request pronoun in the error message" do
        form_object.valid?
        expect(form_object.errors.messages[:currently_in_prison].first).to include("Choose if they are currently in prison")
      end
    end

    describe "current_prison_name" do
      it "does not validate if currently_in_prison is not present" do
        form_object.valid?
        expect(form_object.errors.messages[:current_prison_name]).to be_empty
      end

      context "when currently in prison" do
        it "users the correct error message" do
          form_object.currently_in_prison = "yes"
          form_object.valid?
          expect(form_object.errors.messages[:current_prison_name].first).to include("Enter which prison they are currently in")
        end
      end

      context "when currently not in prison" do
        it "does not validate" do
          form_object.currently_in_prison = "no"
          form_object.valid?
          expect(form_object.errors.messages[:current_prison_name]).to be_empty
        end
      end
    end

    describe "recent_prison_name" do
      it "does not validate if currently_in_prison is not present" do
        form_object.valid?
        expect(form_object.errors.messages[:recent_prison_name]).to be_empty
      end

      context "when currently in prison" do
        it "users the correct error message" do
          form_object.currently_in_prison = "yes"
          form_object.valid?
          expect(form_object.errors.messages[:recent_prison_name]).to be_empty
        end
      end

      context "when currently not in prison" do
        it "users the correct error message" do
          form_object.currently_in_prison = "no"
          form_object.valid?
          expect(form_object.errors.messages[:recent_prison_name].first).to include("Enter which prison they were most recently in")
        end
      end
    end
  end

  describe "#required?" do
    subject(:form_object) { described_class.new }

    before do
      form_object.request = information_request
    end

    context "when request is for prison service information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns false" do
        expect(form_object).to be_required
      end
    end

    context "when request is not for prison service information" do
      let(:information_request) { build(:information_request) }

      it "returns false" do
        expect(form_object).not_to be_required
      end
    end
  end
end
