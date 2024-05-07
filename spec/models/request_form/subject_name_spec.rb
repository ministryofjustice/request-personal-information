require "rails_helper"

RSpec.describe RequestForm::SubjectName, type: :model do
  it_behaves_like "validated attribute with custom message", :full_name, "a name"

  describe "#required?" do
    it { is_expected.to be_required }
  end
end
