RSpec.shared_examples("validated attribute with custom message") do |attribute, valid_value|
  subject(:form_object) { described_class.new }

  let(:pronoun) { "your" }
  let(:information_request) { instance_double(InformationRequest, possessive_pronoun: pronoun) }

  before do
    form_object.request = information_request
  end

  describe "validation" do
    it "validates #{attribute} is present" do
      form_object.send("#{attribute}=", valid_value)
      expect(form_object).to be_valid
    end

    it "uses request pronoun in the error message" do
      form_object.valid?
      expect(form_object.errors.first.message).to include("Enter #{pronoun} #{attribute.to_s.humanize.downcase}")
    end
  end
end
