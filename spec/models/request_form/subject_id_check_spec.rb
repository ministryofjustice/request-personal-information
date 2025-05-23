require "rails_helper"

RSpec.describe RequestForm::SubjectIdCheck, type: :model do
  it_behaves_like "question when requester is not a solicitor"
  it_behaves_like "question with standard saveable attributes"
end
