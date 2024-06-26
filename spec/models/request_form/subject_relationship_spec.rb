require "rails_helper"

RSpec.describe RequestForm::SubjectRelationship, type: :model do
  it_behaves_like "question when requester is not the subject"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:relationship) }
end
