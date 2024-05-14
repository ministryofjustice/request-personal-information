require "rails_helper"

RSpec.describe RequestForm::RequesterDetails, type: :model do
  it_behaves_like "question for friend or family of subject"

  it { is_expected.to validate_presence_of(:requester_name) }
end
