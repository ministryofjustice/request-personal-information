require "rails_helper"

RSpec.describe RequestForm::SolicitorDetails, type: :model do
  it_behaves_like "question for solicitor"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:organisation_name) }
end
