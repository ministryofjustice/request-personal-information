require "rails_helper"

RSpec.describe RequestForm::ContactAddress, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:contact_address) }
end
