require "rails_helper"

RSpec.describe RequestForm::Subject, type: :model do
  it { is_expected.to validate_presence_of(:subject) }

  describe "#required?" do
    it { is_expected.to be_required }
  end
end
