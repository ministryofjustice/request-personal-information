require "rails_helper"

RSpec.describe RequestForm::SubjectDateOfBirth, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "validated attribute with custom message", :date_of_birth, Date.new
  it_behaves_like "question with standard saveable attributes"
end
