require "rails_helper"

RSpec.describe RequestForm::SolicitorDetails, type: :model do
  it { is_expected.to validate_presence_of(:organisation_name) }

  describe "#required?" do
    it { is_expected.to be_required }
  end
end
