require "rails_helper"

RSpec.describe RequestForm::SubjectName, type: :model do
  it_behaves_like "question for everyone"
  it_behaves_like "question with standard saveable attributes"
end
